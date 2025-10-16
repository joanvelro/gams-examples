$onText
-- Scheduling
$offText



Scalar
    qmax_s          'Capacity supply tank'       /500/
    qs0                 'initial stock' /6000/
    qr              'residual' /1000/
    qmax_c          'capacity blending tank'       /10000/;
    
Set
    T             'Time periods'                      / T0*T7/  
    omega_o       'all tanks '                        / O1*O4/
    omega_s       'tanks supply '                     / O1*O2/
    omega_b       'altanks blending '                 / O3*O4/;

ALIAS (omega_o, omega_op) ;

Parameter
    demand(T)    'demand'  /T0 0, T1 1000, T2 1000, T3 1000, T4 1000, T5 1000, T6 1000, T7 1000/
    price(T)    'demand'  /T0 450, T1 500, T2 600, T3 700, T4 500, T5 450, T6 700, T7 450/;
   
Positive Variable
    dummy_var(T)   'variable dummy'
    qc(T)                            'quantity tu purchase'
    qs(T)                     'stock final product'
    stock(T)
    qb(T);
*x(T, omega_o, omega_op)          'quantity that flows';
    
Variable

    z 'dummy objective' ;

Binary Variable
    fb(T)         'Blending flag'
    fc(T)           ''
    fs(T)         'Supply flag';
    


Equations
    dummy    'dummy equation for the objective function'
    supply(T) 
    blending(T)
* stock_eq(T)
limit_blending(T)
    purchase(T) 'purchase of components' ;

dummy..                      z =e= sum(T, fc(T)*qc(T)*price(T));
blending(T)..                qs(T) =g= demand(T);
supply(T)..                  qs(T)=e=qb(T)*fb(T) + stock(T);
purchase(T)..                (1-fb(T))*qb(T+1) =e= qc(T)*fc(T);
*stock_eq(T)..                stock(T+1) =e= stock(T) + qs(T) - demand(T);
limit_blending(T)..            qb(T)*fb(T)=l= 80000;
        


qs.fx('T0')=qs0;
fb.l(T)=1;
fc.l(T)=1;

Model scheduling / all /;

*option minlp=LOCALSOLVER;

OPTION SYSOUT=ON;


solve scheduling using minlp minimizing z;