# -*- coding: utf-8 -*-
#writer : Tomas 

import time
import random
import math
import scipy.stats
import numpy as np

#구간과 도메인의 정의
times = ['A','B','C','D','E','F']                     
domain=[(0,(len(times)*3)-i-1) for i in range(0,len(times)*3)]

#cost function설계를 위한 제약조건 정리
prefs={
       1 : ['B', 'C' , 'A'],
       7 : ['E', 'F'],
       11 : ['A', 'B'],
       15 : ['E', 'D']
       }
       
hates = {
        13 : [1, 7], 
        10 : [11, 15],
        3 : [8, 12, 10]
        }

man = [range(0,12)]
woman = [range(12,18)]        

#vec = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]


def dormcost(vec):
    
    #선호하는 시간대에 따라 점수부여 
    
    #싫어하는 사람에 따라 점수부여 
    
    #각 시간대에 적어도 1명은 남자
    
    #C시간대에 여자가 있으면 안됨 
    
  cost=0
  
  # Create list a of slots
  slots=[]
  for i in range(len(times)): slots+=[i,i,i]
  
  #해 vec에 따른 시간대 설정
  times_band = printsolution(vec)
  
  #선호하는 시간대에 따라 점수부여 
  for i in prefs.keys():
      time=times_band[i]
      pref=prefs[i]
      
      satisfy = False
      for j in range(len(pref)):           
          if pref[j]==time: 
              cost+=(j*2)
              satisfy = True
      if satisfy == False:
          cost+=(j*2+3)
          
  #싫어하는 사람에 따라 점수부여 
  for i in hates.keys():
      time=times_band[i]
      ha=hates[i]
      
      for j in range(len(ha)):
          y = int(vec[ha[j]])
          time_y=times[slots[y]]           
          if time_y==time: 
              cost+=(7-j)
              

  #각 방에 적어도 1명은 남자  
  idx = 0 
  time_dic = {'A':0 , 'B':0 , 'C':0 , 'D':0 , 'E':0 , 'F':0} 
  
  for t in times_band:
      idx += 1
      if idx >=0 and idx <= 11:
          if t == 'A': time_dic['A'] += 1
          elif t == 'B': time_dic['B'] += 1
          elif t == 'C': time_dic['C'] += 1
          elif t == 'D': time_dic['D'] += 1
          elif t == 'E': time_dic['E'] += 1
          elif t == 'F': time_dic['F'] += 1
  
  #페널티를 2점씩 부과해준다.         
  cost += sum(matrix(time_dic.values()) == 0) * 2
       
  #C시간대에 여자가 있으면 안됨 
  idx = 0 
  time_dic = {'A':0 , 'B':0 , 'C':0 , 'D':0 , 'E':0 , 'F':0} 
  
  for t in times_band:
      idx += 1
      if idx >=12:
          if t == 'C': time_dic['C'] += 1
          
  if time_dic['C']>0 : cost+=10 #페널티 10점 부과
  
  return cost
  

def printsolution(vec):
  slots = []
  times_band = []
  
  # 슬롯초기화
  for i in range(len(times)): slots+=[i,i,i]

  # 루프를 돌면서 전직원들의 시간배정
  for i in range(len(vec)):
    x=int(vec[i])

    # 직원의 시간대를 정한다. 
    time=times[slots[x]]
    
    #시간대를 추가함. 
    times_band.append(time)
    
    # 해당하는 슬롯삭제(이미 배정되었으므로)
    del slots[x]
    
  return times_band


def geneticoptimize(domain,costf=dormcost,popsize=200,step=1,
                    mutprob=0.5,elite=0.4,maxiter=20):
  # 변이
  def mutate(vec):
    i=random.randint(0,len(domain)-1)
    if random.random()<0.5 and vec[i]-step>domain[i][0]:
      return vec[0:i]+[vec[i]-step]+vec[i+1:] 
    elif vec[i]+step<domain[i][1]:
      return vec[0:i]+[vec[i]+step]+vec[i+1:]
    else:
      return vec
  
  # 교차연산
  def crossover(r1,r2):
    i=random.randint(1,len(domain)-1)
    return r1[0:i]+r2[i:]

  # 초기의 random 해 설정
  pop=[]
  for i in range(popsize):
    vec=[random.randint(domain[i][0],domain[i][1]) 
         for i in range(len(domain))]
    pop.append(vec)
  
  # 엘리트해의 개수의 설정
  topelite=int(elite*popsize)
  
  
  # 메인루프
  for i in range(maxiter):
    scores=[(costf(v),v) for v in pop]
    scores.sort()
    ranked=[v for (s,v) in scores]
    
    # 엘리트해의 추출
    pop=ranked[0:topelite]
    
    # 변이와 교차의 반복. popsize만큼. 
    while len(pop)<popsize:
      if random.random()<mutprob:

        # 변이
        c=random.randint(0,topelite)
        pop.append(mutate(ranked[c]))
      else:
      
        # 교차(싱글)
        c1=random.randint(0,topelite)
        c2=random.randint(0,topelite)
        pop.append(crossover(ranked[c1],ranked[c2]))
    
    # 현재까지의 최적해 출력
    print i,scores[0][0],'--->',scores[0][1] , '==>' , printsolution(scores[0][1])
    
  return scores[0][1]
