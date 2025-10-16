$onText
-- Economics, maximize profit in a market where the selling price depends on the quantity
$offText

Scalars

P0 /7.29434228/
P1 /-1.13348497e+03 /
P2 / 4.21654262e+04/
C0 /10/
*price /500/
D /100/;

Parameters
K /A1 1.2, A2 1.3, A3 1.1/
LL /A1 20, A2 20, A3 20/
UL /A1 80, A2 80, A3 80/;

Sets
A 'agents' /A1*A3/;


Variables
P 'profit';

Positive Variables
C(A) 'cost'
price 
XT 'total quantity'
x(A) 'quantity produced by each agent';


Equations
price_equation
quantity_equation
cost_equation(A)
upper_limit_agent(A)
lower_limit_agent(A)
demand_equation
profit_equation;

profit_equation..      P =e= sum(A, x(A) * (price - C(A)));

cost_equation(A)..     C(A)=e= k(A)*x(A);

upper_limit_agent(A)..       x(A)=l= UL(A);

lower_limit_agent(A)..       x(A)=g= LL(A); 

demand_equation..      XT=e=D;

quantity_equation..    XT =e= sum(A, x(A));

price_equation..        price=e= 5- 0.12*XT ;





*x.up(A)=20

*X.l=1

Model economics / all /;

*not feasible solution
* option minlp=BONMIN; 
*not integer solution
*option minlp=DICOPT;

option nlp=LOCALSOLVER;

*option minlp=BARON;
 
*option minlp=KNITRO;

*option minlp=XPRESS;

*option minlp=SCIP;

*option minlp=SHOT;


*OPTION SYSOUT=ON;

solve economics using nlp maximizing P;