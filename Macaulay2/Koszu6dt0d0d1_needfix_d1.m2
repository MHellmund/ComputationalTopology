--ulimit -v unlimited;ulimit -d unlimited; GC_NPROCS=4 GC_MARKERS=4 M2 Koszul10d.m2
t1 = cpuTime()
-- needsPackage "DGAlgebras"
-- needsPackage "BoijSoederberg"
-- needsPackage "ChainComplexExtras"
D=6
spindim=8
Nsusy=1
Nspin=spindim*Nsusy
msusy=id_(ZZ^Nsusy)
kk= ZZ/32003
----b=partial/partial C, e=partial/partial theta, p=partial/partial x----
--R=kk[t_1..t_Nspin,b_1..b_D,SkewCommutative =>{b_1..b_D}]
--R=kk[t_1..t_Nspin,b_1..b_D,SkewCommutative =>{b_1,b_2,b_3,b_4,b_5,b_6,b_7,b_8,b_9,b_10}]
--R=kk[t_1..t_Nspin,b_1..b_D,SkewCommutative =>apply(toList(1..D),i->b_i),Degrees=>apply(toList(1..Nspin),i->{1,0})|apply(toList(1..D),i->{0,1})]
R=kk[t_1..t_Nspin,b_1..b_D,e_1..e_Nspin,SkewCommutative =>apply(toList(1..D),i->b_i)|apply(toList(1..Nspin),i->e_i),Degrees=>apply(toList(1..Nspin),i->{1,0,0})|apply(toList(1..D),i->{0,1,0})|apply(toList(1..Nspin),i->{0,0,1})]
Rx=kk[p_1..p_D]
degx=8
genx=apply(toList(1..D),i->p_i^degx)
Rx=Rx/ideal(genx)
ofilename="result_cohgen"|D|"dN"|Nsusy|"dt0d0d1.txt"
ofile=ofilename<<""<<endl
--ofile<<run "hostname"<<run "date"<<endl


-- DiracC1.DiracGamma;DiracB1.DiracGamma --
----NEED to check all relations: Tleft*gamma*Tright!=0----  
gamma={matrix{{0, 0, 0, 0, 0, -1, 0, 0}, {0, 0, 0, 0, 1, 0, 0, 0}, {0, 0, 0, 0, 0, 
  0, 0, 1}, {0, 0, 0, 0, 0, 0, -1, 0}, {0, 1, 0, 0, 0, 0, 0, 0}, {-1, 
  0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, -1, 0, 0, 0, 0}, {0, 0, 1, 0, 0, 0, 
  0, 0}}**msusy,
--
matrix{{0, 0, 0, 0, 0, 1, 0, 0}, {0, 0, 0, 0, -1, 0, 0, 0}, {0, 0, 0, 0, 0, 
  0, 0, 1}, {0, 0, 0, 0, 0, 0, -1, 0}, {0, -1, 0, 0, 0, 0, 0, 0}, {1, 
  0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, -1, 0, 0, 0, 0}, {0, 0, 1, 0, 0, 0, 
  0, 0}}**msusy,
--
matrix{{0, 0, 0, 0, 0, 0, 0, 1}, {0, 0, 0, 0, 0, 0, -1, 0}, {0, 0, 0, 0, 0, 
  1, 0, 0}, {0, 0, 0, 0, -1, 0, 0, 0}, {0, 0, 0, -1, 0, 0, 0, 0}, {0, 
  0, 1, 0, 0, 0, 0, 0}, {0, -1, 0, 0, 0, 0, 0, 0}, {1, 0, 0, 0, 0, 0, 
  0, 0}}**msusy,
--
matrix{{0, 0, 0, 0, 0, 0, 0, -1}, {0, 0, 0, 0, 0, 0, 1, 0}, {0, 0, 0, 0, 0, 
  1, 0, 0}, {0, 0, 0, 0, -1, 0, 0, 0}, {0, 0, 0, -1, 0, 0, 0, 0}, {0, 
  0, 1, 0, 0, 0, 0, 0}, {0, 1, 0, 0, 0, 0, 0, 0}, {-1, 0, 0, 0, 0, 0, 
  0, 0}}**msusy,
--
matrix{{0, 0, 0, -1, 0, 0, 0, 0}, {0, 0, 1, 0, 0, 0, 0, 0}, {0, 1, 0, 0, 0, 
  0, 0, 0}, {-1, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, -1}, {0, 
  0, 0, 0, 0, 0, 1, 0}, {0, 0, 0, 0, 0, 1, 0, 0}, {0, 0, 0, 0, -1, 0, 
  0, 0}}**msusy,
--
matrix{{0, 0, 0, 1, 0, 0, 0, 0}, {0, 0, -1, 0, 0, 0, 0, 0}, {0, -1, 0, 0, 0,
   0, 0, 0}, {1, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, -1}, {0, 
  0, 0, 0, 0, 0, 1, 0}, {0, 0, 0, 0, 0, 1, 0, 0}, {0, 0, 0, 0, -1, 0, 
  0, 0}}**msusy}


redux = ()->(
	M=prune M;  --also improve the ambient free module --
	--M=trim M;  --faster--
	s = reduceHilbert(hilbertSeries(M));
	NumgenM=numgens M;
	GenM=generators M;
--	resM=resolution(M);
	resM=resolution(M,LengthLimit=>10);
	B=betti(resM);
	<<"(D="<<D<<")_s"<<n<<"="<<s<<endl;
	<<"Number of "<<n<<"-th cohomology generators="<<NumgenM<<endl;
	<<"The "<<n<<"-th cohomology generators are:"<<GenM<<endl;
	 <<"The resolution of M_"<<n<<": "<<endl<<resM<<endl;
	 <<"The Betti diagram of the free resolution of M_"<<n<<": "<<endl<<B<<endl;
	ofile<<"(D="<<D<<")_s"<<n<<"="<<s<<endl;
	ofile<<"Number of "<<n<<"-th cohomology generators="<<NumgenM<<endl;
	ofile<<"The "<<n<<"-th cohomology generators are:"<<GenM<<endl;
	 ofile<<"The resolution of M_"<<n<<": "<<endl<<resM<<endl;
	 ofile<<"The Betti diagram of the free resolution of M_"<<n<<": "<<endl<<B<<endl;
)

use R
Tleft = matrix{{t_1..t_Nspin}};
Tright= matrix{{t_1}..{t_Nspin}};
clist= matrix{{b_1}..{b_D}}
thetalist= matrix{{e_1}..{e_Nspin}}
xlist= matrix{{p_1}..{p_D}}
d1=sum(0..(D-1),i->Tleft*(gamma#i)*Tright*clist^{i})+Tleft*thetalist
--d1=sum(0..(D-1),i->Tleft*(gamma#i)*Tright*clist^{i})
d2=map(source d1,,d1)
C=new ChainComplex; C.ring = R;
C#0 = target d1; C#1 = source d1; C#2 = source d2;
C.dd#1 = d1; C.dd#2 = d2;
--C
M = HH_1 C;
redux()

RRx=R**Rx
use RRx
K=M**RRx
Tleft = matrix{{t_1..t_Nspin}};
Tright= matrix{{t_1}..{t_Nspin}};
clist= matrix{{b_1}..{b_D}}
thetalist= matrix{{e_1}..{e_Nspin}}
xlist= matrix{{p_1}..{p_D}}
dx=sum(0..(D-1),i->Tleft*(gamma#i)*thetalist*xlist^{i})
dx1=map(K, K, dx)
M=(ker dx1)/(image dx1)
redux()

t2 = cpuTime()
<<"The time takes in this computation process: "<<t2-t1<<endl
ofile<<"The time takes in this computation process: "<<t2-t1<<endl

ofile<<close
<< get ofilename