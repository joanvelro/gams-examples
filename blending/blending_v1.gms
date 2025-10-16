$onText
-- Blending 1.0
$offText


Scalar
    QD            'Demanda total a suplir (Tm)'     /30000/
    Qmin          'Cantidad minima a comprar'       /500/
    Qmax          'Cantidad maxima a comprar'       /10000/
    densidad_max  'Limite maximo Densidad'          /1.2/
    sulfuro_max   'Limite maximo Sulfuro (Azufre)'  /0.5/;
    
Set
    C             'componentes'                     / C1,C2,C3  /
    T             'tanques '                        / T1*T3  /;

Parameter
    Price_c(C)    'Precios netos componentes $/Tm'  / C1 470, C2 400, C3 460 /
    Price_s(T)    'Precios netos Stocks $/Tm'       / T1 450, T2 430, T3 400 /
    
    sulfuro_c(C)  'Sulfuro componentes'             / C1 0.47, C2 0.37, C3 0.45 /
    sulfuro_s(T)  'Sulfuro stock'                   / T1 0.45, T2 0.44, T3 0.48 /
    
    densidad_c(C) 'Densidad Componentes'            / C1 0.88, C2 0.90, C3 0.87 /
    densidad_s(T) 'Densidad Tanques'                / T1 0.89, T2 0.9, T3 0.88 /
    
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
    CT             ' coste total';

Equations
    total_cost    'Ecuacion coste total'
    demanda       'Ecuación de produccion igual o superior a demanda'
    Q_min_comp(C) 'Cantidad minima de compra de componente'
    Q_max_comp(C) 'Cantidad maxima de compra de componente'
    sulfuro_final
    densidad_final
    total_quantity
    limite_sulfuro
    limite_densidad
    limite_stock(T);

total_cost..                CT =e= sum(C, Qc(C)*Price_c(C)) + sum(T, Qs(T)*Price_s(T)) ;
      
total_quantity..            QT =e= sum(C, Qc(C)) + sum(T, Qs(T)) ;
                  
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
yc.l(C) = 1;
ys.l(T) = 1;

Model blending / all /;

*option minlp=BONMIN;

option minlp=LOCALSOLVER;

OPTION SYSOUT=ON;

solve blending using minlp minimizing CT;
                        




 
