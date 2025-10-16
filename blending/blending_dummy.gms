$onText
-- Blending problem 
$offText


Scalar
    QD            'Demanda total a suplir (Tm)'     /30000/
    Qmin          'Cantidad minima a comprar'       /500/
    Qmax          'Cantidad maxima a comprar'       /10000/
    densidad_max  'Limite maximo Densidad'          /0.95/
    P_venta       'Precio venta ($/Tm)'             /500/
    sulfuro_max   'Limite maximo Sulfuro (Azufre)'  /0.5/;
    
Set
    C             'componentes'                     / C1,C2,C3  /
    T             'tanques '                        / T1*T3  /;

Parameter
    Price_c(C)    'Precios netos componentes $/Tm'  / C1 470, C2 400, C3 460 /
    Price_s(T)    'Precios netos Stocks $/Tm'       / T1 450, T2 430, T3 400 /
    
    sulfuro_c(C)  'Sulfuro componentes'             / C1 0.57, C2 0.47, C3 0.45 /
    sulfuro_s(T)  'Sulfuro stock'                   / T1 0.52, T2 0.51, T3 0.51 /
    
    densidad_c(C) 'Densidad Componentes'            / C1 0.93, C2 0.92, C3 0.87 /
    densidad_s(T) 'Densidad Tanques'                / T1 0.89, T2 0.9, T3 0.98 /
    
    stock(T)      'Stock producto final'            /T1 1450, T2 1350, T3 1260/;
   
Positive Variable
    Qc(C)         'Cantidad de componente a comprar'
    Qs(T)         'Cantidad de stock a usar';
    
Positive Variable
    QT            'Cantidad total a producir'
    densidad      'Densidad producto final'
    sulfuro       'Sulfuro (Azufre) producto final';

Binary Variable
    yc(C)         'Variable binaria componentes'
    ys(T)         'Variable binaria tanques';
    
Variable
    B              'Beneficios'
    CT             'Coste total';

Equations
    coste_total    'Ecuacion coste total'
    beneficios
    demanda        'Ecuacion de demanda (Ingresos-costes)'
    Q_min_comp(C) 'Cantidad minima de compra de componente'
    Q_max_comp(C) 'Cantidad maxima de compra de componente'
    sulfuro_final
    densidad_final
    total_quantity
    limite_sulfuro
    limite_densidad
    limite_stock(T);

coste_total..               CT =e= sum(C, Qc(C)*Price_c(C)) + sum(T, Qs(T)*Price_s(T)) ;

total_quantity..            QT =e= sum(C, Qc(C)) + sum(T, Qs(T)) ;

beneficios..                B =e= (P_venta*QT - CT )/ QT;
                  
demanda..                   QT =g= QD ;

Q_min_comp(C)..             Qc(C) - yc(C)*Qmin =g=0 ;

Q_max_comp(C)..             Qc(C) - yc(C)*Qmax =l=0;

limite_stock(T)..           Qs(T) - ys(T)*stock(T) =l= 0 ;

sulfuro_final..             sulfuro =e= 1/QT* (sum(C, sulfuro_c(C) * Qc(C) ) + sum(T, sulfuro_s(T) * Qs(T) )) ;
    
densidad_final..            densidad =e= 1/QT* (sum(C, densidad_c(C) * Qc(C) ) + sum(T, densidad_s(T) * Qs(T) )) ;

limite_sulfuro..            sulfuro =l= sulfuro_max;

limite_densidad..           densidad =l= densidad_max;               


Qc.l(C) = 1;
Qs.l(T) = 1;
QT.l = 1;


Model blending / all /;

*not feasible solution
* option minlp=BONMIN; 
*not integer solution
*option minlp=DICOPT;


*option minlp=BARON;
 
*option minlp=KNITRO;

*option minlp=XPRESS;

option minlp=LOCALSOLVER;

*option minlp=SCIP;

*option minlp=SHOT;


OPTION SYSOUT=ON;

*solve blending using minlp minimizing CT;
solve blending using minlp maximizing B;
                        




 
