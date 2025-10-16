$onText
-- Economics, maximize profit in a market where the selling price depends on the quantity
$offText

Scalars
P0 /3.96032302/
P1 /-52.14594279/
P2 /102.33508465/
C0 /10/
D /1000/
price /500/;

Parameters
K /A1 10, A2 8, A3 12/;

Sets
A 'agents' /A1*A3/;

Variables
P 'profit'
C(A) 'cost'
*X(A) 'total quantity'
x(A) 'quantity produced by each agent';

Equations
*price_equation
*quantity_equation
cost_equation(A)
demand_equation
profit_equation;

profit_equation..      P =e= sum(A, x(A) * (price - C(A))) / sum(A, x(A));

cost_equation(A)..     C(A)=e=K(A)*log(x(A));



demand_equation..      sum(A, x(A))=g=D;

*price_equation..        price=e= P0*X**2 + P1*X + P2;

*quantity_equation..    X=e=sum(A, x(A));





x.l(A)=1
*X.l=1

Model economics / all /;

*not feasible solution
* option minlp=BONMIN; 
*not integer solution
*option minlp=DICOPT;


*option minlp=BARON;
 
*option minlp=KNITRO;

*option minlp=XPRESS;

*option minlp=SCIP;

*option minlp=SHOT;


*OPTION SYSOUT=ON;

solve economics using nlp maximizing P;