pro program_demo1
;  a=findgen(4,6)
;  b=3
;  c=[3]
;  d=[9,3,1]
;  print,'a[3,4]:',a[3,4]
;  print,'a[15]:',a[15]
;  print,'a+b:',a+b
;  print,'a[1,1]+b:',a[1,1]+b
;  print,'a+c:',a+c
;  print,'a+d:',a+d

;  a=[[3,9,10],[2,7,5],[4,1,6]] 
;  print,a
;  b=[[7,10,2],[5,8,9],[3,1,6]]
;  print,b
;  print,a+b
;  print,"a+b=",a*b
  a=[[0,5,3],[4,0,2],[0,7,8]]
  b=[[0,0,1],[9,7,4],[1,0,2]]
;  c=(a gt 3)*a
;  d=(b gt 3)*b
;  e=(b le 4)*b+(b gt 4)*9
;  print,'a=',a,'b=',b
;  print,'c=',c,'d=',d
;  print,'e=',e
  f=float(a+b)/2.0
  g=(a gt 0)+(b gt 0)
  h=float(a+b)/g
  print,g
  print,f
  print,h
  hdf_sd_fileinfo
end