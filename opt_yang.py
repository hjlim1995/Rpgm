# -*- coding: utf-8 -*-
#writer : Tomas 

import time
import random
import math
import scipy.stats
import numpy as np

#지도행렬 만들기
map_mat = [[0,1,1,0,0,0,0,0,0,0] , 
            [0,0,0,1,0,0,0,0,0,0] , 
            [0,0,0,0,1,0,0,0,0,0] , 
            [0,0,0,0,1,0,1,0,0,0] , 
            [0,0,0,1,0,0,0,0,1,0] , 
            [0,0,0,0,0,0,0,0,0,0] , 
            [0,0,0,1,0,1,0,0,0,0] , 
            [0,0,0,0,0,0,0,0,0,0] , 
            [0,0,0,0,1,0,0,0,0,1] , 
            [0,0,0,0,0,0,0,0,0,0]]

#행렬의 길이            
node_cnt = np.shape(map_mat)[0]
connected_list = []
for x in map_mat:
    connected = []
    cnt = 0 
    for i in x:
        cnt += 1
        if i>0 :
            connected.append(cnt) 
    connected_list.append(connected) 

#지도행렬을 bool행렬로 변환    
mat_tf = np.matrix(map_mat) > 0 

#domain범위 리스트
domain = []
for i in mat_tf:
    if sum(i).any() > 0 :
        tu = 1,sum(i)
    else :
        tu = 0,0
         
    domain.append(tu) 
    print(tu) 

#시작점과 끝점 설정하기    
start = 1 
end = 10 
#vec = [2, 1, 1, 1, 2, 0, 2, 0, 2, 0]


def ret_path(sol , start=start , end=end):
    
    vec = sol    
    vec2 = [0,0,0,0,0,0,0,0,0,0]
    path = [start]
    node = start 
    rotate = 0 
    
    while True:
        rotate += 1 
        
        #막다른 골목이면 멈춘다. 
        if len(connected_list[node-1]) == 0 :
            break
        
        #다음에 방문할 노드를 찾는다.     
        next1 = connected_list[node-1][vec[node-1]-1]
        vec2[node-1] = vec[node-1]
        path.append(next1) 
        node = next1
        path_len = len(path) - 1
        
        if next1 == end :
            break
        if rotate > node_cnt :
            break
            
    return path , vec2 #vec과 vec2의 다른점은 vec2는 방문하지 않는 곳은 아예 0으로 저장한다. 


def costfunc(sol):
    val_sum = 0.0
    
    path , vec2 = ret_path(sol , start , end)
    
    if len(path) > node_cnt:
        return 999
    if path[len(path)-1] != end:
        return 999
        
    #추가로 rule을 넣을 수도 있고 가중치를 수정할 수도 있음. 
    #....
	
    val_sum = len(path)-1
    
    return val_sum


def geneticoptimize(domain,costf=costfunc,popsize=100,step=1,
                    mutprob=0.5,elite=0.4,maxiter=20):
  # 변이연산
  def mutate(vec):
    i=random.randint(0,len(domain)-1)
    
    if domain[i][0] > 0 :
        return vec
    
    #step값의 변경이 도메인의 범위를 넘지 않도록 한다. 
    if random.random()<0.5 and vec[i]-step>domain[i][0]:
      ret_vec = vec[0:i]+[vec[i]-step]+vec[i+1:] 
    elif vec[i]+step<domain[i][1]:
      ret_vec = vec[0:i]+[vec[i]+step]+vec[i+1:]
    else:
      ret_vec = vec
      
    #print('변이 : ' , ret_vec) 
    
    return ret_vec
  
  # 교차연산
  def crossover(r1,r2):
    i=random.randint(1,len(domain)-1)
    return r1[0:i]+r2[i:]

  # random해를 popsize만큼 만든다. 
  pop=[]
  for i in range(popsize):
    vec=[random.randint(domain[i][0],domain[i][1]) 
         for i in range(len(domain))]
    pop.append(vec)
  
  # 엘리트해의 비율만큼 엘리트해의 개수설정
  topelite=int(elite*popsize)
  
  
  # 메인루프 
  for i in range(maxiter):
    scores=[(costf(v),v) for v in pop]
    scores.sort()
    ranked=[v for (s,v) in scores]
    
    #엘리트해를 추출한다. 
    pop=ranked[0:topelite]
    
    # 일정한 확률로 변이와 교차를 반복하여 popsize만큼의 해를 확보한다. 
    while len(pop)<popsize:
      if random.random()<mutprob:

        # 변이
        c=random.randint(0,topelite)
        pop.append(mutate(ranked[c]))
      else:
      
        # 교차
        c1=random.randint(0,topelite)
        c2=random.randint(0,topelite)
        pop.append(crossover(ranked[c1],ranked[c2]))
    
    # 현재까지 가장 좋은 해를 출력한다. 
    print (i,scores[0][0],'==> PATH:' , ret_path(scores[0][1]))
    
  return ret_path(scores[0][1])
