
calculate.covariance <- function(initial.parameters,theta.lb,theta.ub,y.data,x.data,stage,lambda.g=NA,lambda.z=NA,xi.00){

  n.state.vars <- length(xi.00)

  P.00 <- diag(0.2,n.state.vars,n.state.vars)

  f <- function(theta) {return(-log.likelihood.wrapper(theta, y.data, x.data, stage, lambda.g, lambda.z, xi.00, P.00)$ll.cum)}
  nloptr.out <- nloptr(initial.parameters, f, eval_grad_f=function(x) {gradient(f, x)},
                       lb=theta.lb,ub=theta.ub,opts=list("algorithm"="NLOPT_LD_LBFGS","xtol_rel"=1.0e-8))
  theta <- nloptr.out$solution

  states <- kalman.states.wrapper(theta, y.data, x.data, stage, lambda.g, lambda.z, xi.00, P.00)

  P.00 <- states$filtered$P.ttm1[1:n.state.vars,]
  
  return(P.00)
}

