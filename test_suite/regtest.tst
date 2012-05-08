#
# test REGULARISE
#

\set time slow
\rele print CROUTPUT:
#use reginit.dat

#title test 1

#regular keep
group 6
old  C(1)  C(2)  C(3)  O(4)  C(5) q(6)
phen
end
#disp hi                                                                        
end

#EDIT                                                                           
DELETE Q(6)
END
#title test 2

#regular keep                                                                
group 6
old  C(1)  C(2)  C(3)  O(4)  C(5) q(6)
new  C(101)  C(102)  C(103)  O(104)  C(105) q(106)
end
#disp hi                                                                        
end

#use reginit.dat

#title test 3

#regular keep                                                                
group 6
old  q(6) C(1)  C(2)  C(3)  O(4)  C(5) 
phen
end
#disp hi                                                                        
end

#EDIT                                                                           
DELETE Q(6)
END
#title test 4

#regular keep                                                                
group 6
old  q(6) C(1)  C(2)  C(3)  O(4)  C(5) 
new  q(106) C(101)  C(102)  C(103)  O(104)  C(105) 
end
#disp hi                                                                        
end

#title augment

#use reginit.dat

#title test 5

#regular augment
group 6
old  C(1)  C(2)  C(3)  O(4)  C(5) q(6)
phen
end
#disp hi                                                                        
end

#EDIT                                                                           
DELETE Q(6)
END

#title test 6
#regular augment                                                             
group 6
old  C(1)  C(2)  C(3)  O(4)  C(5) q(6)
new  C(101)  C(102)  C(103)  O(104)  C(105) q(106)
end
#disp hi                                                                        
end

#use reginit.dat

#title test 7

#regular augment                                                                
group 6
old  q(6) C(1)  C(2)  C(3)  O(4)  C(5) 
phen
end
#disp hi                                                                        
end

#EDIT                                                                           
DELETE Q(6)
END

#title test 8


#regular replace                                                                
group 6
old  q(6) C(1)  C(2)  C(3)  O(4)  C(5) 
new  q(106) C(101)  C(102)  C(103)  O(104)  C(105) 
end
#disp hi                                                                        
end


# replace

#use reginit.dat

#title test 9
#regular replace
group 6
old  C(1)  C(2)  C(3)  O(4)  C(5) q(6)
phen
end
#disp hi                                                                        
end

#EDIT                                                                           
DELETE Q(6)
END

#title test 10
#regular replace                                                             
group 6
old  C(1)  C(2)  C(3)  O(4)  C(5) q(6)
new  C(101)  C(102)  C(103)  O(104)  C(105) q(106)
end
#disp hi                                                                        
end

#use reginit.dat

#title test 11

#regular replace                                                             
group 6
old  q(6) C(1)  C(2)  C(3)  O(4)  C(5) 
phen
end
#disp hi                                                                        
end

#EDIT                                                                           
DELETE Q(6)
END

#title test 12
#regular replace                                                             
group 6
old  q(6) C(1)  C(2)  C(3)  O(4)  C(5) 
new  q(106) C(101)  C(102)  C(103)  O(104)  C(105) 
end
#disp hi                                                                        
end


#use reginit.dat

#title test 13
#regular replace                                                                
group 6
old  C(1)  C(2)  C(3)  O(4)  C(5) q(6)
new  C(101)  C(102)  C(103)  O(104)  C(105) q(106)
#edit
change first(residue) until last 0
insert residue
end

#title test 14

#MATCH                                                                          
MAP
CONTINUE  C(1)
CONTINUE  C(2)
CONTINUE  C(3)
CONTINUE  O(4)
CONTINUE  C(5)
CONTINUE  Q(6)
CONTINUE  O(51)
CONTINUE  N(52)
ONTO RESI(2)
END



#end

