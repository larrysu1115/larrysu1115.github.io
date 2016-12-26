cal_recursive <- function(k, lamb) {
  if (k <= 0) {
    return(exp(-lamb))
  }
  return(cal_recursive(k-1,lamb) * lamb / k)
}

cal_pos <- function(k, lamb, n, actual) {
  e <- exp(1)

  # 利用原始Poisson公式計算 approx. poisson P(X=k)
  k_fact <- factorial(k)
  e_over_neg_lamb <- e ^ (-lamb)
  lamb_over_k <- lamb ^ k
  p <- lamb_over_k / k_fact * e_over_neg_lamb

  # 利用遞迴方式計算 approx. poisson P(X=k)
  p_recur <- rr <- cal_recursive(k=k, lamb=lamb)

  # 利用Bin(n,p)方式計算準確 P(X=k)
  rp <- lamb / 280
  r <- choose(n,k) * (rp^k) * ((1-rp)^(n-k))
  print(sprintf(
    paste('某團年有%d人死的機率',
          'p = %.5f ~ %.5f (Pois趨近公式) = %.5f (Pois趨近回歸),',
          '估計有 %7.3f 個[團年]死亡 %d 人, 實際:%3d')
    , k, r, p, p_recur, p*n, k, actual))
}
actual_nums <- c(144,91,32,11,2,0,0,0)
for (k in c(0:7)) cal_pos(k=k, lamb=0.7, n=280, actual=real_nums[k+1])
