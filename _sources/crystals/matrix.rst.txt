.. toctree::
   :maxdepth: 1
   :caption: Contents:

   
   
      

*******************
Matrix Calculations
*******************


.. _matrixcalc:

 

.. index:: Matrix Calculator


====================================
The Basic Matrix Calculator \\MATRIX
====================================


::


    \MATRIX 
    A      
    B      
    MM     
    TM     
    MT     
    TT     
    TRANS  
    INV    
    EIG    
    ACC2A  
    ACC2B  
    EXECUTE
    END
   
    \MATRIX
    A 1 2 3 4 5 6 7 8 9
    B 4 5 6 7 8 9 10 11 12
    MM
    END
   






CRYSTALS contains a simple calculator for processing 3x3 matrices. Two 
matrices, A and B, can be input and operated on. The result is output to
the screen and left in an accumulator.  It can be transfered to A or B 
for further operations.  There is currently no interface to any stored 
crystallographic information.




--------
\\MATRIX
--------

   
   
   
   
   

**A**



   
   Followed by the nine values for the matrix A by rows
   
   
   

**B**



   
   Followed by the nine values for the matrix B by rows
   
   
   

**MM**



   
   Accumulator = AxB
   
   
   

**TM**



   
   Accumulator = A'xB
   
   
   

**MT**



   
   Accumulator = AxB'
   
   
   

**TT**



   
   Accumulator = A'xB'
   
   
   

**TRANS**



   
   Accumulator = A'
   
   
   

**INV**



   
   Accumulator = A-1
   
   
   

**EIG**



   
   Accumulator = Eigenvectors of A
   
   
   

**ACC2A**



   
   Matrix A = Accumulator
   
   
   

**ACC2B**



   
   Matrix B = Accumulator
   
   
   

**EXECUTE**



   
   Forces execution of the last directive
   
   
   
   
   
