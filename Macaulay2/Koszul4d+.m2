--Author: Renjun Xu
--E-mail: rxu@ucdavis.edu
--This projected is licensed under the terms of the MIT license.

--ulimit -v unlimited;ulimit -d unlimited; GC_NPROCS=4 GC_MARKERS=4 M2 Koszul10d.m2
t1 = cpuTime()
needsPackage "DGAlgebras"
needsPackage "BoijSoederberg"
-- needsPackage "ChainComplexExtras"
D=4;
spindim=4;
Nsusy=1;
Nspin=spindim*Nsusy;
msusy=id_(ZZ^Nsusy);
kk= ZZ/32003;
R=QQ[t_1..t_Nspin];
ofilename="result_cohgen"|D|"dN"|Nsusy|"dKoszul.txt"
ofile=ofilename<<""<<endl
--ofile<<run "hostname"<<run "date"<<endl

gamma={matrix{{0, 0, -1, 0}, {0, 0, 0, -1}, {-1, 0, 0, 0}, {0, -1, 0, 0}}**msusy,
			matrix{{0, 0, 1, 0}, {0, 0, 0, -1}, {1, 0, 0, 0}, {0, -1, 0, 0}}**msusy,
			matrix{{0, -1, 0, 0}, {-1, 0, 0, 0}, {0, 0, 0, 1}, {0, 0, 1, 0}}**msusy,
			matrix{{0, 1, 0, 0}, {1, 0, 0, 0}, {0, 0, 0, 1}, {0, 0, 1, 0}}**msusy};

--calculate the cohomologies from n0 to nmax at reduced dimension iDim--
redux = (n0,nmax,iDim)->(
n:=n0;M=1;while n<=nmax and M!=0 do
	(
			M=symbol M;
			M = HH_n K;
			M=prune M;--also improve the ambient free module --
--			M=trim M;--faster--
			s = reduceHilbert(hilbertSeries(M));
			NumgenM=numgens M;
			GenM=generators M;
--!Resolution can't be derived after RingMap since we'll over QuotientRing, NOT PolynomialRing!--
--		use R;
--		M=map(R,ring M)**M;	--map M from the QuotientRing to PolynomialRing--
--		resM=resolution(map(R,ring M)**M);
			resM=res pushForward(map(ring M,R), M);
			B=betti(resM);
--		use ring M;
			<<"(D="<<(iDim+1)<<"+"<<(D-iDim-1)<<")_s"<<n<<"="<<s<<endl;
			<<"Number of "<<n<<"-th cohomology generators="<<NumgenM<<endl;
			<<"The "<<n<<"-th cohomology generators are:"<<GenM<<endl;
			<<"The resolution of M_"<<n<<": "<<endl<<resM<<endl;
			<<"The Betti diagram of the free resolution of M_"<<n<<": "<<endl<<B<<endl;
			ofile<<"(D="<<(iDim+1)<<"+"<<(D-iDim-1)<<")_s"<<n<<"="<<s<<endl;
			ofile<<"Number of "<<n<<"-th cohomology generators="<<NumgenM<<endl;
			ofile<<"The "<<n<<"-th cohomology generators are:"<<GenM<<endl;
			ofile<<"The resolution of M_"<<n<<": "<<endl<<resM<<endl;
			ofile<<"The Betti diagram of the free resolution of M_"<<n<<": "<<endl<<B<<endl;
			s=symbol s; NumgenM=symbol NumgenM; GenM=symbol GenM; resM=symbol resM; B=symbol B; 
			n=n+1;
			)
)

Tleft = matrix{{t_1..t_Nspin}};	Tright= matrix{{t_1}..{t_Nspin}};
--Ilist=apply(toList(0..(D-1)),i->Tleft*(gamma#i)*Tright)
Ilist=apply(toList(0..(D-1)),i->(Tleft*(gamma#i)*Tright)_(0,0))	--to get a list, not matrix--
gamma=symbol gamma; spindim=symbol spindim; Nspin=symbol Nspin; msusy=symbol msusy; Tleft=symbol Tleft; Tright=symbol Tright; 
--M0list={}
M0=R;
--resolution: set isubDim=10--
isubDim=0;deltas0=0;while isubDim<=D-1 and deltas0==0 do 
(
	ofile<<"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"<<endl<<"D="<<(isubDim+1)<<"+"<<(D-isubDim-1)<<",NSusy="<<Nsusy<<":"<<endl;
	<<"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"<<endl<<"D="<<(isubDim+1)<<"+"<<(D-isubDim-1)<<",NSusy="<<Nsusy<<":"<<endl;
--	Tleft = matrix{{t_1..t_Nspin}};	Tright= matrix{{t_1}..{t_Nspin}};
--	I0 = ideal(Tleft*(gamma#isubDim)*Tright);
	I0 = ideal((map(M0,R)) (Ilist_isubDim));
--	A = koszulComplexDGA(I0);--over the ideal--
--  K = toComplex koszulComplexDGA(I0);--over the ideal--
--
		M00=M0;
		M0=M0/I0;--New QuotientRing applied--
--	M0=prune M0; --NO prune, otherwise would change the ring--
		M0=trim M0;--faster--
--	M0list=M0list | {M0};
		s0 =reduceHilbert(hilbertSeries(M0));
		use ring (numerator s0);
		deltas0=(numerator s0)-(1+T)^(isubDim+1);	 --isubDim+1 since count from 0--
		T=symbol T;
  if deltas0==0 then
  	(
--		use M0;	--current step still need to work over M00--
--	M0^1=module(M0)--
		NumgenM=numgens M0^1;
		GenM=generators M0^1;
		resM=res (R^1 / flattenRing(M0,Result=>Ideal));
--	resM=res (R^1 / ideal (flattenRing(M0,Result=>Thing)));
		B=betti(resM);
		use M0;
		<<"(D="<<(isubDim+1)<<"+"<<(D-isubDim-1)<<")_s0="<<s0<<endl;
		<<"Number of 0-th cohomology generators="<<NumgenM<<endl;
		<<"The 0-th cohomology generators are:"<<GenM<<endl;
			<<"The resolution of M_"<<n<<": "<<endl<<resM<<endl;
			<<"The Betti diagram of the free resolution of M_"<<n<<": "<<endl<<B<<endl;
		ofile<<"(D="<<(isubDim+1)<<"+"<<(D-isubDim-1)<<")_s0="<<s0<<endl;
		ofile<<"Number of 0-th cohomology generators="<<NumgenM<<endl;
		ofile<<"The 0-th cohomology generators are:"<<GenM<<endl;
			ofile<<"The resolution of M_"<<n<<": "<<endl<<resM<<endl;
			ofile<<"The Betti diagram of the free resolution of M_"<<n<<": "<<endl<<B<<endl;
		isubDim=isubDim+1;
		)
)
--isubDim quit at 5, i.e. D=6+4--

use M00;
idimS1=isubDim	 --record where isubDim exit--
--Tleft = matrix{{t_1..t_Nspin}};Tright= matrix{{t_1}..{t_Nspin}};
--Mlist={}
I1={}
--I1={Tleft*(gamma#5)*Tright,Tleft*(gamma#6)*Tright,Tleft*(gamma#7)*Tright}
--!Resolution can't be easy derived with induction method since we'll over QuotientRing, NOT PolynomialRing!--
--!resolution: for i from 0!--
--for isubDim from idimS1+1 to D-1 do
for isubDim from idimS1 to D-1 do --if isubDim quit at idimS1--
(
	ofile<<"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"<<endl<<"D="<<(isubDim+1)<<"+"<<(D-isubDim-1)<<":"<<endl;
	<<"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"<<endl<<"D="<<(isubDim+1)<<"+"<<(D-isubDim-1)<<",NSusy="<<Nsusy<<":"<<endl;
--	I1=I1|{Tleft*(gamma#isubDim)*Tright};
	I1=I1|{(map(M00,R)) (Ilist_isubDim)};
	I=ideal(I1);
--	rR=M0/I;
--  A = koszulComplexDGA(rR);
--	A = koszulComplexDGA(I);--over the ideal--
--	apply(maxDegree A + 1, j -> numgens prune homology(j,A));
	K = toComplex koszulComplexDGA(I);--over the ideal--
-- K.dd;
	redux(0,isubDim,isubDim);
)

t2 = cpuTime()
<<"The time takes in this computation process: "<<t2-t1<<endl;
ofile<<"The time takes in this computation process: "<<t2-t1<<endl;

ofile<<close
<< get ofilename
