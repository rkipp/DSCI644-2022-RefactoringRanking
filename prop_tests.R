

# check low vs. ex high
low_ex_high_ada = 115
low_ex_high_hib = 43
low_ada = 315
low_hib = 63
# H0: p_ada = p_hib, HA: p_ada < p_hib
# p-value = 3.039e-06
prop.test(x = c(low_ex_high_ada, low_ex_high_hib),
          n = c(low_ada, low_hib),
          alternative = "less")

# check medium vs. ex high
med_ex_high_ada = 96
med_ex_high_hib = 78
med_ada = 388
med_hib = 183
# H0: p_ada = p_hib, HA: p_ada < p_hib
# p-value = 1.146e-05
prop.test(x = c(med_ex_high_ada, med_ex_high_hib),
          n = c(med_ada, med_hib),
          alternative = "less")

