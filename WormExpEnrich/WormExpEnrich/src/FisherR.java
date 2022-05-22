package com.dem.stat;
import java.lang.Double;
import java.lang.Object;
public class FisherR {

	static final double M_LN_2PI=1.837877066409345483560659472811;
	static final double pi = 3.141592653589793238462643383279502884197;
	static final double sqrtpi = 1.772453850905516027298167483341145182798;
	static final double M_LN_SQRT_2PI=0.918938533204672741780329736406;
	static final double M_LN_SQRT_PId2=0.225791352644727432363097614947;
	static final double DBL_EPSILON = 2.2204e-16;
	static final double M_LN2=0.693147180559945309417232121458;
	public FisherR()
	{
		
	}
	
	
	public double pdhyper (double x, double NR, double NB, double n, boolean log_p)
	{
	/*
	 * Calculate
	 *
	 *	    phyper (x, NR, NB, n, TRUE, FALSE)
	 *   [log]  ----------------------------------
	 *	       dhyper (x, NR, NB, n, FALSE)
	 *
	 * without actually calling phyper.  This assumes that
	 *
	 *     x * (NR + NB) <= n * NR
	 *
	 */
	    double sum = 0;
	    double term = 1;

	    while (x > 0 && term >= DBL_EPSILON * sum) {
		term *= x * (NB - n + x) / (n + 1 - x) / (NR + 1 - x);
		sum += term;
		x--;
	    }
	    
	    double ss = (double) sum;
	    return log_p ? Math.log1p(ss) : 1 + ss;
	}


	/* FIXME: The old phyper() code was basically used in ./qhyper.c as well
	 * -----  We need to sync this again!
	*/
	public double phyper (int x, int NR, int NB, int n,
		       boolean lower_tail, boolean log_p)
	{
	/* Sample of  n balls from  NR red  and	 NB black ones;	 x are red */

	    double d, pd;

	    x =(int) Math.floor (x + 1e-7);

	    if (NR < 0 || NB < 0 || Double.isInfinite(NR + NB) || n < 0 || n > NR + NB) return(Double.NaN);
	    if (x * (NR + NB) > n * NR) {
		/* Swap tails.	*/
		int oldNB = NB;
		NB = NR;
		NR = oldNB;
		x = n - x - 1;
		lower_tail = !lower_tail;
	    }

	    if (x < 0)
		return lower_tail ? R_D_0(log_p) : R_D_1(log_p);
	    if (x >= NR || x >= n)
		return lower_tail ? R_D_1(log_p) : R_D_0(log_p);

	    d  = dhyper (x, NR, NB, n, log_p);
	    pd = pdhyper(x, NR, NB, n, log_p);
	    double pbuf=d * pd, pbuf1=lower_tail ? (pbuf) : (0.5 - (pbuf) + 0.5);
	    return log_p ? R_DT_Log(d + pd,lower_tail,log_p) : pbuf1;
	}
	private double R_DT_Log(double p,boolean lower_tail,boolean log_p)
	{
		double p1= log_p	?  (p)	 : Math.log(p);
		double p0= ((p) > -M_LN2 ? Math.log(-Math.expm1(p)) : Math.log1p(-Math.exp(p)));
		double p2= log_p ? p0 : Math.log1p(-p);
		return lower_tail? p1 : p2;
	}
	
	public double dhyper(int x, int r, int b, int n, boolean give_log)
	{
	    double p, q, p1, p2, p3;


	    if (n > r+b) throw new IllegalArgumentException("Invalid distribution parameter.");
	    if(x < 0) return(0.0);

	   

	    if (n < x || r < x || n - x > b) return(0.0);
	    if (n == 0) return((x == 0) ? 1.0 : 0.0);

	    p = ((double)n)/((double)(r+b));
	    q = ((double)(r+b-n))/((double)(r+b));

	    p1 = dbinom_raw(x,	r, p,q,give_log);
	    p2 = dbinom_raw(n-x,b, p,q,give_log);
	    p3 = dbinom_raw(n,r+b, p,q,give_log);

	    return( (give_log) ? p1 + p2 - p3 : p1*p2/p3 );
	}
	private double R_D_exp(double lc,boolean give_log)
	{
		return( (give_log)?lc:Math.exp(lc));
	}
	private double R_D_0(boolean give_log)
	{
		return( (give_log)?Double.NEGATIVE_INFINITY:0.0);
	}
	private double R_D_1(boolean give_log)
	{
		return( (give_log)?0.0:1.0);
	}
	public double dbinom_raw(double x, double n, double p, double q, boolean give_log)
	{
	    double lf, lc;

	    if (p == 0) return((x == 0) ? R_D_1(give_log) : R_D_0(give_log));
	    if (q == 0) return((x == n) ? R_D_1(give_log) : R_D_0(give_log));

	    if (x == 0) {
		if(n == 0) return R_D_1(give_log);
		lc = (p < 0.1) ? -bd0(n,n*q) - n*p : n*Math.log(q);
		return( R_D_exp(lc,give_log) );
	    }
	    if (x == n) {
		lc = (q < 0.1) ? -bd0(n,n*p) - n*q : n*Math.log(p);
		return( R_D_exp(lc,give_log) );
	    }
	    if (x < 0 || x > n) return( R_D_0(give_log) );

	    /* n*p or n*q can underflow to zero if n and p or q are small.  This
	       used to occur in dbeta, and gives NaN as from R 2.3.0.  */
	    lc = stirlerr(n) - stirlerr(x) - stirlerr(n-x) - bd0(x,n*p) - bd0(n-x,n*q);

	    /* f = (M_2PI*x*(n-x))/n; could overflow or underflow */
	    /* Upto R 2.7.1:
	     * lf = log(M_2PI) + log(x) + log(n-x) - log(n);
	     * -- following is much better for  x << n : */
	    lf = M_LN_2PI + Math.log(x) + Math.log1p(- x/n);

	    return R_D_exp(lc - 0.5*lf,give_log);
	}
	private double bd0(double x, double np)
	{
	    double ej, s, s1, v;
	    int j;

	    if(!IsFinite(x) || !IsFinite(np) || np == 0.0) throw new IllegalArgumentException("Invalid distribution parameter.");

	    if (Math.abs(x-np) < 0.1*(x+np)) {
		v = (x-np)/(x+np);  // might underflow to 0
		s = (x-np)*v;/* s using v -- change by MM */
		if(Math.abs(s) < Double.MIN_VALUE) return s;
		ej = 2*x*v;
		v = v*v;
		for (j = 1; j < 1000; j++) { /* Taylor series; 1000: no infinite loop
						as |v| < .1,  v^2000 is "zero" */
		    ej *= v;// = v^(2j+1)
		    s1 = s+ej/((j<<1)+1);
		    if (s1 == s) /* last term was effectively 0 */
			return s1 ;
		    s = s1;
		}
	    }
	    /* else:  | x - np |  is not too small */
	    return(x*Math.log(x/np)+np-x);
	}
	 public static boolean IsFinite(double value)
     {
         return !Double.isNaN(value) && !Double.isInfinite(value);
     }
	 private double stirlerr(double n)
	 {

		 double S0 =0.083333333333333333333;       /* 1/12 */
		 double S1 =0.00277777777777777777778;     /* 1/360 */
	     double S2 =0.00079365079365079365079365;  /* 1/1260 */
	     double S3 =0.000595238095238095238095238; /* 1/1680 */
	     double S4 =0.0008417508417508417508417508;/* 1/1188 */

	 /*
	   error for 0, 0.5, 1.0, 1.5, ..., 14.5, 15.0.
	 */
	    double [] sferr_halves = {
	 	0.0, /* n=0 - wrong, place holder only */
	 	0.1534264097200273452913848,  /* 0.5 */
	 	0.0810614667953272582196702,  /* 1.0 */
	 	0.0548141210519176538961390,  /* 1.5 */
	 	0.0413406959554092940938221,  /* 2.0 */
	 	0.03316287351993628748511048, /* 2.5 */
	 	0.02767792568499833914878929, /* 3.0 */
	 	0.02374616365629749597132920, /* 3.5 */
	 	0.02079067210376509311152277, /* 4.0 */
	 	0.01848845053267318523077934, /* 4.5 */
	 	0.01664469118982119216319487, /* 5.0 */
	 	0.01513497322191737887351255, /* 5.5 */
	 	0.01387612882307074799874573, /* 6.0 */
	 	0.01281046524292022692424986, /* 6.5 */
	 	0.01189670994589177009505572, /* 7.0 */
	 	0.01110455975820691732662991, /* 7.5 */
	 	0.010411265261972096497478567, /* 8.0 */
	 	0.009799416126158803298389475, /* 8.5 */
	 	0.009255462182712732917728637, /* 9.0 */
	 	0.008768700134139385462952823, /* 9.5 */
	 	0.008330563433362871256469318, /* 10.0 */
	 	0.007934114564314020547248100, /* 10.5 */
	 	0.007573675487951840794972024, /* 11.0 */
	 	0.007244554301320383179543912, /* 11.5 */
	 	0.006942840107209529865664152, /* 12.0 */
	 	0.006665247032707682442354394, /* 12.5 */
	 	0.006408994188004207068439631, /* 13.0 */
	 	0.006171712263039457647532867, /* 13.5 */
	 	0.005951370112758847735624416, /* 14.0 */
	 	0.005746216513010115682023589, /* 14.5 */
	 	0.005554733551962801371038690  /* 15.0 */
	     };
	     double nn;
	     double mlnpi=0.918938533204672741780329736406;
	     if (n <= 15.0) {
	 	nn = n + n;
	 	if (nn == (int)nn) return(sferr_halves[(int)nn]);
	 	return(lgammafn(n + 1.) - (n + 0.5)*Math.log(n) + n - mlnpi);
	     }

	     nn = n*n;
	     if (n>500) return((S0-S1/nn)/n);
	     if (n> 80) return((S0-(S1-S2/nn)/nn)/n);
	     if (n> 35) return((S0-(S1-(S2-S3/nn)/nn)/nn)/n);
	     /* 15 < n <= 35 : */
	     return((S0-(S1-(S2-(S3-S4/nn)/nn)/nn)/nn)/n);
	 }
	 double lgammafn(double x)
	 {
	     double ans, y, sinpiy;

	
	 double xmax = 2.5327372760800758e+305;
	 double dxrel = 1.490116119384765625e-8;


	     if (x <= 0 && x == trunc(x)) { /* Negative integer argument */
	 	   return Double.POSITIVE_INFINITY;/* +Inf, since lgamma(x) = log|gamma(x)| */
	     }

	     y = Math.abs(x);

	     if (y < 1e-306) return -Math.log(y); // denormalized range, R change
	     if (y <= 10) return Math.log(Math.abs(gammafn(x)));
	     /*
	       ELSE  y = |x| > 10 ---------------------- */

	     if (y > xmax) {
	    	 return Double.POSITIVE_INFINITY;
	     }

	     if (x > 0) { /* i.e. y = x > 10 */
	 	    return M_LN_SQRT_2PI + (x - 0.5) * Math.log(x) - x + lgammacor(x);
	     }
	     /* else: x < -10; y = -x */
	     sinpiy = Math.abs(sinpi(y));

	     if (sinpiy == 0) { /* Negative integer argument ===
	 			  Now UNNECESSARY: caught above */
	      return Double.NaN;
	     }

	     ans = M_LN_SQRT_PId2 + (x - 0.5) * Math.log(y) - x - Math.log(sinpiy) - lgammacor(y);

	     if(Math.abs((x - trunc(x - 0.5)) * ans / x) < dxrel) {

	    	 throw new IllegalArgumentException("Invalid distribution parameter.");
	     }

	     return ans;
	 }
	  private static double trunc(double paramDouble)
	  {
	    if (paramDouble >= 0.0D) {
	      return Math.floor(paramDouble);
	    }
	    return -Math.floor(Math.abs(paramDouble));
	  }

	 
	private double gammafn(double x)
	 {
       double [] gamcs = {
	 	+.8571195590989331421920062399942e-2,
	 	+.4415381324841006757191315771652e-2,
	 	+.5685043681599363378632664588789e-1,
	 	-.4219835396418560501012500186624e-2,
	 	+.1326808181212460220584006796352e-2,
	 	-.1893024529798880432523947023886e-3,
	 	+.3606925327441245256578082217225e-4,
	 	-.6056761904460864218485548290365e-5,
	 	+.1055829546302283344731823509093e-5,
	 	-.1811967365542384048291855891166e-6,
	 	+.3117724964715322277790254593169e-7,
	 	-.5354219639019687140874081024347e-8,
	 	+.9193275519859588946887786825940e-9,
	 	-.1577941280288339761767423273953e-9,
	 	+.2707980622934954543266540433089e-10,
	 	-.4646818653825730144081661058933e-11,
	 	+.7973350192007419656460767175359e-12,
	 	-.1368078209830916025799499172309e-12,
	 	+.2347319486563800657233471771688e-13,
	 	-.4027432614949066932766570534699e-14,
	 	+.6910051747372100912138336975257e-15,
	 	-.1185584500221992907052387126192e-15,
	 	+.2034148542496373955201026051932e-16,
	 	-.3490054341717405849274012949108e-17,
	 	+.5987993856485305567135051066026e-18,
	 	-.1027378057872228074490069778431e-18,
	 	+.1762702816060529824942759660748e-19,
	 	-.3024320653735306260958772112042e-20,
	 	+.5188914660218397839717833550506e-21,
	 	-.8902770842456576692449251601066e-22,
	 	+.1527474068493342602274596891306e-22,
	 	-.2620731256187362900257328332799e-23,
	 	+.4496464047830538670331046570666e-24,
	 	-.7714712731336877911703901525333e-25,
	 	+.1323635453126044036486572714666e-25,
	 	-.2270999412942928816702313813333e-26,
	 	+.3896418998003991449320816639999e-27,
	 	-.6685198115125953327792127999999e-28,
	 	+.1146998663140024384347613866666e-28,
	 	-.1967938586345134677295103999999e-29,
	 	+.3376448816585338090334890666666e-30,
	 	-.5793070335782135784625493333333e-31
	     };

	     int i, n;
	     double y;
	     double sinpiy, value;

	     int  ngam= 22;
	     double xmin= -170.5674972726612;
	     double xmax=  171.61447887182298;
	     double xsml= 2.2474362225598545e-308;
	     double dxrel= 1.490116119384765696e-8;

	     if(Double.isNaN(x)) return x;

	     /* If the argument is exactly zero or a negative integer
	      * then return NaN. */
	     if (x == 0 || (x < 0 && x == Math.round(x))) {
	 	   return Double.NaN;
	     }

	     y = Math.abs(x);

	     if (y <= 10) {

	 	/* Compute gamma(x) for -10 <= x <= 10
	 	 * Reduce the interval and find gamma(1 + y) for 0 <= y < 1
	 	 * first of all. */

	 	n = (int) x;
	 	if(x < 0) --n;
	 	y = x - n;/* n = floor(x)  ==>	y in [ 0, 1 ) */
	 	--n;
	 	value = chebyshev_eval(y * 2 - 1, gamcs, ngam) + .9375;
	 	if (n == 0)
	 	    return value;/* x = 1.dddd = 1+y */

	 	if (n < 0) {
	 	    /* compute gamma(x) for -10 <= x < 1 */

	 	    /* exact 0 or "-n" checked already above */

	 	    /* The answer is less than half precision */
	 	    /* because x too near a negative integer. */
	 	    if (x < -0.5 && Math.abs(x - (int)(x - 0.5) / x) < dxrel) {
	 	    	throw new IllegalArgumentException("Invalid distribution parameter.");
	 	    }

	 	    /* The argument is so close to 0 that the result would overflow. */
	 	    if (y < xsml) {
	 		if(x > 0) return Double.POSITIVE_INFINITY;
	 		else return Double.NEGATIVE_INFINITY;
	 	    }

	 	    n = -n;

	 	    for (i = 0; i < n; i++) {
	 		value /= (x + i);
	 	    }
	 	    return value;
	 	}
	 	else {
	 	    /* gamma(x) for 2 <= x <= 10 */

	 	    for (i = 1; i <= n; i++) {
	 		value *= (y + i);
	 	    }
	 	    return value;
	 	}
	     }
	     else {
	 	/* gamma(x) for	 y = |x| > 10. */

	 	if (x > xmax) {			/* Overflow */
	 	    return Double.POSITIVE_INFINITY;
	 	}

	 	if (x < xmin) {			/* Underflow */
	 	    return 0.;
	 	}

	 	if(y <= 50 && y == (int)y) { /* compute (n - 1)! */
	 	    value = 1.;
	 	    for (i = 2; i < y; i++) value *= i;
	 	}
	 	else { /* normal case */
	 	    value = Math.exp((y - 0.5) * Math.log(y) - y + M_LN_SQRT_2PI +
	 			((2*y == (int)2*y)? stirlerr(y) : lgammacor(y)));
	 	}
	 	if (x > 0)
	 	    return value;

	 	if (Math.abs((x - (int)(x - 0.5))/x) < dxrel){

	 	    /* The answer is less than half precision because */
	 	    /* the argument is too near a negative integer. */

	 		throw new IllegalArgumentException("Invalid distribution parameter.");
	 	}

	 	sinpiy = sinpi(y);
	 	if (sinpiy == 0) {		/* Negative integer arg - overflow */
	 	    return Double.POSITIVE_INFINITY;
	 	}

	 	return -pi / (y * sinpiy * value);
	     }
	 }
	private double chebyshev_eval(double x, double [] a,  int n)
	{
	    double b0, b1, b2, twox;
	    int i;

	    if (n < 1 || n > 1000) return Double.NaN;

	    if (x < -1.1 || x > 1.1) return Double.NaN;

	    twox = x * 2;
	    b2 = b1 = 0;
	    b0 = 0;
	    for (i = 1; i <= n; i++) {
		b2 = b1;
		b1 = b0;
		b0 = twox * b1 - b2 + a[n - i];
	    }
	    return (b0 - b2) * 0.5;
	}
	static double 
	sinpi(double x)
	{
	    double y, r;
	    int n;

	    y = Math.abs(x) % 2.0;
	    n = (int)Math.round(2.0*y);

	    assert((0 <= n) && (n <= 4));

	    switch (n) {
	    case 0:
	        r = Math.sin(pi*y);
	        break;
	    case 1:
	        r = Math.cos(pi*(y-0.5));
	        break;
	    case 2:
	        /* N.B. -sin(pi*(y-1.0)) is *not* equivalent: it would give
	           -0.0 instead of 0.0 when y == 1.0. */
	        r = Math.sin(pi*(1.0-y));
	        break;
	    case 3:
	        r = -Math.cos(pi*(y-1.5));
	        break;
	    case 4:
	        r = Math.sin(pi*(y-2.0));
	        break;
	    default:
	        assert(false);  /* should never get here */
	        r = 3; // Make javac happy
	    }

	    return Math.copySign(1.0, x)*r;
	}
	private double lgammacor(double x)
	{
	     double [] algmcs = {
		+.1666389480451863247205729650822e+0,
		-.1384948176067563840732986059135e-4,
		+.9810825646924729426157171547487e-8,
		-.1809129475572494194263306266719e-10,
		+.6221098041892605227126015543416e-13,
		-.3399615005417721944303330599666e-15,
		+.2683181998482698748957538846666e-17,
		-.2868042435334643284144622399999e-19,
		+.3962837061046434803679306666666e-21,
		-.6831888753985766870111999999999e-23,
		+.1429227355942498147573333333333e-24,
		-.3547598158101070547199999999999e-26,
		+.1025680058010470912000000000000e-27,
		-.3401102254316748799999999999999e-29,
		+.1276642195630062933333333333333e-30
	    };

	    double tmp;

	/* For IEEE double precision DBL_EPSILON = 2^-52 = 2.220446049250313e-16 :
	 *   xbig = 2 ^ 26.5
	 *   xmax = DBL_MAX / 48 =  2^1020 / 3 */
	int nalgm =5;
	double xbig =94906265.62425156;
	double xmax = 3.745194030963158e306;

	    if (x < 10) return Double.NaN;
	    else if (x >= xmax) {
	    	throw new IllegalArgumentException("Invalid distribution parameter.");
		/* allow to underflow below */
	    }
	    else if (x < xbig) {
		tmp = 10 / x;
		return chebyshev_eval(tmp * tmp * 2 - 1, algmcs, nalgm) / x;
	    }
	    return 1 / (x * 12);
	}
}
