# set working directory


setwd("C:/Users/buchwala/OneDrive - The University of Colorado Denver/Covid-private/Rfiles/covid_private") 
pop <- read.csv('./copop.csv')
#pIDstate <-read.csv("C:/Users/buchwala/OneDrive - The University of Colorado Denver/Carlton Lab Folder/COVID19/RegionalModels/DATA/pIDstate1228.csv", header = TRUE, na.strings =".")


# load packages

library(deSolve)

# read in spreadsheet
setwd("C:/Users/buchwala/OneDrive - The University of Colorado Denver/Covid-private/Rfiles")
scen <- read.csv('./Model params.csv')

# build SEIR model as an R function

seir1 <- function(t, x, parms) {
  
  with(as.list(c(parms, x)), {
    
    # change over time in efficacy of % mag SD among specific age groups
    
    ef1 <- ifelse(t<t2, mag1, ifelse(t<t2a, mag2, ifelse(t<t3, mag2a, ifelse(t<t3a, mag3, ifelse(t<t4, mag3a, ifelse(t<t5, mag4, ifelse(t<t6, mag5, ifelse(t<t6a, mag6, ifelse (t<t6b, mag6a, ifelse(t<t7, mag6b, 
           ifelse(t<t8, mag7, ifelse (t<t9, mag8, ifelse(t<t10, mag9, ifelse (t<t11, mag10, ifelse(t<t12,mag11, ifelse(t<t13,mag12, ifelse(t<t14, mag13, ifelse(t<t15,mag14, ifelse(t<t16, mag15, ifelse(t<t17, mag16, 
           ifelse(t<t18, mag17, ifelse(t<t19, mag18, ifelse(t<t20, mag19, ifelse(t<ttraj, mag20, ifelse(t<tproject,traj, ifelse(t<tpa, ef1_2, ifelse (t<tpb, ef1_3, ifelse(t<tpc, ef1_4, ef1_5))))))))))))))))))))))))))))
    ef4 <- ef1
    
    CT  <- ifelse(t < t6, 0, pCT)
    #temp <- ifelse (t > 1, ifelse(temp_on == 1, temptheory$temp.param[[t]],1), 1)
    temp <-ifelse(temp_on == 1, 0.5*cos((t+45)*0.017)+1.5, 1)
    clos4 <- ifelse(t<99, 10.82, 8)
    hlos4 <- ifelse(t<99, 10.02, 7.6)
    clos3 <- ifelse(t<99, 13.47, 8.5)
    hlos3 <- ifelse(t<99, 7.36,  5.3)
    clos2 <- ifelse(t<99, 9.91,  4.4)
    hlos2 <- ifelse(t<99, 5.49,  3.6)
    clos1 <- ifelse(t<99, 7.00,  4)
    hlos1 <- ifelse(t<99, 4.05,  5.0)
    dh3 <- ifelse(t<160, dh3, dh3_2)
    dh4 <- ifelse(t<160, dh4, dh4_2)
    dc3 <- ifelse(t<160, dc3, dc3_2)
    dc4 <- ifelse(t<160, dc4, dc4_2)
    
    cc2 <- ifelse(t < 147, cc2a, ifelse(t < 234, cc2b, cc2c))
    cc3 <- ifelse(t < 147, cc3a, ifelse(t < 234, cc3b, cc3c))
    cc4 <- ifelse(t < 147, cc4a, ifelse(t < 234, cc4b, cc4c))
    
    vac1 <- ifelse(t<359, 0, ifelse(t< 380, vac1*0.9, ifelse(t<400, vac1a*0.9, ifelse(t<tvacend, vac1b*0.9,0))))
    vac2 <- ifelse(t<359, 0, ifelse(t< 380, vac2*0.9, ifelse(t<400, vac2a*0.9, ifelse(t<tvacend, vac2b*0.9,0))))
    vac3 <- ifelse(t<359, 0, ifelse(t< 380, vac3*0.9, ifelse(t<400, vac3a*0.9, ifelse(t<tvacend, vac3b*0.9,0))))
    vac4 <- ifelse(t<359, 0, ifelse(t< 380, vac4*0.9, ifelse(t<400, vac4a*0.9, ifelse(t<tvacend, vac4b*0.9,0))))
    
    
    dS1  <-    - (I1+I2+I3+I4)*(beta*temp*lambda*S1*(1-ef1))/N - (beta*temp*S1*(A1+A2+A3+A4)*(1-ef1))/N + (R1+Rh1+Rc1)*(1/dimmuneI) + RA1*(1/dimmuneA) - vac1*(S1/n1) + V1*(1/vd)
    dE1  <-    - E1/alpha   + (I1+I2+I3+I4)*(beta*temp*lambda*S1*(1-ef1))/N + (beta*temp*S1*(A1+A2+A3+A4)*(1-ef1))/N 
    dI1  <- (E1*pS1)/alpha - I1*(gamma) -  I1*CT
    dII1 <-                         (I1+A1)*CT - II1*gamma
    dIh1 <- I1*hosp1*gamma + II1*pS1*hosp1*gamma - Ih1/hlos1
    dIc1 <- I1*cc1*gamma   + II1*pS1*cc1*gamma- Ic1/clos1 
    dA1  <- (E1*(1-pS1))/alpha - A1*gamma - A1*CT
    dR1  <- (I1+II1*pS1)*(gamma*(1-hosp1-cc1-dnh1))  - R1*(1/dimmuneI)
    dRA1 <-  (A1 + II1*(1-pS1))*gamma                - RA1*(1/dimmuneA)
    dRh1 <- (1-dh1)*(Ih1/hlos1) - Rh1*(1/dimmuneI)
    dRc1 <- (1-dc1)*(Ic1/clos1) - Rc1*(1/dimmuneI)
    dV1  <- vac1*(S1/n1) - V1*(1/vd)
    dD1  <-     dc1*Ic1*(1/clos1) + dh1*(Ih1/hlos1)+ dnh1*(I1+II1*pS1)*gamma
    
    dS2  <-    - (I1+I2+I3+I4)*(beta*temp*lambda*S2*(1-ef1))/N - (beta*temp*S2*(A1+A2+A3+A4)*(1-ef1))/N + (R2+Rh2+Rc2)*(1/dimmuneI) + RA2*(1/dimmuneA)  - vac2*(S2/n2) + V2*(1/vd)
    dE2  <-    - E2/alpha   + (I1+I2+I3+I4)*(beta*temp*lambda*S2*(1-ef1))/N + (beta*temp*S2*(A1+A2+A3+A4)*(1-ef1))/N 
    dI2  <- (E2*pS2)/alpha - I2*(gamma) -  I2*CT
    dII2 <-                         (I2+A2)*CT - II2*gamma
    dIh2 <- I2*hosp2*gamma + II2*pS2*hosp2*gamma - Ih2/hlos2
    dIc2 <- I2*cc2*gamma   + II2*pS2*cc2*gamma - Ic2/clos2 
    dA2  <- (E2*(1-pS2))/alpha - A2*gamma - A2*CT
    dR2  <- (I2+II2*pS2)*(gamma*(1-hosp2-cc2-dnh2))  - R2*(1/dimmuneI)
    dRA2 <-  (A2 + II2*(1-pS2))*gamma                - RA2*(1/dimmuneA)
    dRh2 <- (1-dh2)*(Ih2/hlos2) - Rh2*(1/dimmuneI)
    dRc2 <- (1-dc2)*(Ic2/clos2) - Rc2*(1/dimmuneI)
    dV2  <- vac2*(S2/n2) - V2*(1/vd)
    dD2  <-     dc2*Ic2*(1/clos2) + dh2*Ih2*(1/hlos2)+ dnh2*(I2+II2*pS2)*gamma
    
    dS3  <-    - (I1+I2+I3+I4)*(beta*temp*lambda*S3*(1-ef1))/N - (beta*temp*S3*(A1+A2+A3+A4)*(1-ef1))/N + (R3+Rh3+Rc3)*(1/dimmuneI) + RA3*(1/dimmuneA) - vac3*(S3/n3) + V3*(1/vd)
    dE3  <-    - E3/alpha   + (I1+I2+I3+I4)*(beta*temp*lambda*S3*(1-ef1))/N + (beta*temp*S3*(A1+A2+A3+A4)*(1-ef1))/N 
    dI3  <- (E3*pS3)/alpha - I3*(gamma)  - I3*CT
    dII3 <-                         (I3+A3)*CT - II3*gamma
    dIh3 <- I3*hosp3*gamma + II3*pS3*hosp3*gamma - Ih3/hlos3
    dIc3 <- I3*cc3*gamma   + II3*pS3*cc3*gamma - Ic3/clos3 
    dA3  <- (E3*(1-pS3))/alpha - A3*gamma - A3*CT
    dR3  <- (I3+II3*pS3)*(gamma*(1-hosp3-cc3-dnh3))  - R3*(1/dimmuneI)
    dRA3 <-  (A3 + II3*(1-pS3))*gamma                - RA3*(1/dimmuneA)
    dRh3 <- (1-dh3)*(Ih3/hlos3) - Rh3*(1/dimmuneI)
    dRc3 <- (1-dc3)*(Ic3/clos3) - Rc3*(1/dimmuneI)
    dV3  <- vac3*(S3/n3) - V3*(1/vd)
    dD3  <-    dc3 *Ic3*(1/clos3) + dh3*Ih3*(1/hlos3) + dnh3*(I3+II3*pS3)*gamma
    
    dS4  <-    - (I1+I2+I3+I4)*(beta*temp*lambda*S4*(1-ef4))/N - (beta*temp*S4*(A1+A2+A3+A4)*(1-ef4))/N + (R4+Rh4+Rc4)*(1/dimmuneI)+RA4*(1/dimmuneA)  - vac4*(S4/n4) + V4*(1/vd)
    dE4  <-    - E4/alpha   + (I1+I2+I3+I4)*(beta*temp*lambda*S4*(1-ef4))/N + (beta*temp*S4*(A1+A2+A3+A4)*(1-ef4))/N 
    dI4  <- (E4*pS4)/alpha - I4*(gamma)  - I4*CT
    dII4 <-                         (I4+A4)*CT - II4*gamma
    dIh4 <- I4*hosp4*gamma + II4*pS4*hosp4*gamma - Ih4/hlos4
    dIc4 <- I4*cc4*gamma   + II4*pS4*cc4*gamma- Ic4/clos4 
    dA4  <- (E4*(1-pS4))/alpha - A4*gamma - A4*CT
    dR4  <- (I4+II4*pS4)*(gamma*(1-hosp4-cc4-dnh4))  - R4*(1/dimmuneI)
    dRA4 <-  (A4 + II4*(1-pS4))*gamma                - RA4*(1/dimmuneA)
    dRh4 <- (1-dh4)*(Ih4/hlos4) - Rh4*(1/dimmuneI)
    dRc4 <- (1-dc4)*(Ic4/clos4) - Rc4*(1/dimmuneI)
    dV4  <- vac4*(S4/n4) - V4*(1/vd)
    dD4  <-    dc4* Ic4*(1/clos4) + dh4*Ih4*(1/hlos4) + dnh4*(I4+II4*pS4)*gamma
    
    
    
    return(list(c(dS1, dE1, dI1, dII1, dIh1, dIc1, dA1, dR1, dRA1, dRh1, dRc1, dV1, dD1,
                  dS2, dE2, dI2, dII2, dIh2, dIc2, dA2, dR2, dRA2, dRh2, dRc2, dV2, dD2,
                  dS3, dE3, dI3, dII3, dIh3, dIc3, dA3, dR3, dRA3, dRh3, dRc3, dV3, dD3,
                  dS4, dE4, dI4, dII4, dIh4, dIc4, dA4, dR4, dRA4, dRh4, dRc4, dV4, dD4), 
                
                incI = (I1 + I2 + I3 + I4)/9,
                incA = (A1 + A2 + A3 + A4)/9,
                Iht = Ih1+Ih2+Ih4+Ih3+Ic1+Ic2+Ic4+Ic3, 
                Ict = Ic1+Ic2+Ic4+Ic3,
                Iht1 = Ih1+Ic1,
                Iht2 = Ih2+Ic2,
                Iht3 = Ih3+Ic3,
                Iht4 = Ih4+Ic4,
                Dt = D1 + D2 + D3 + D4,
                Rt = R1+Rh1+Rc1+D1+R2+Rh2+Rc2+D2+R3+Rh3+Rc3+D3+R4+Rh4+Rc4+D4+RA1+RA2+RA3+RA4,
                Rht = Rh1+Rc1+Rh2+Rc2+Rh3+Rc3+Rh4+Rc4+Ih1+Ih2+Ih4+Ih3+Ic1+Ic2+Ic4+Ic3,
                Itotal = I1+I2+I3+I4 +A1+A2+A3+A4,
                Etotal = E1 + E2 + E3 + E4,
                Vt = V1 + V2 + V3 + V4,
                IIt = II1 + II2 + II3 + II4))
  })
}

#temptheory <- read.csv('./temptheory.csv')

# rows (n) to represent scenario numbers
n <- as.numeric(nrow(scen)) 
covid_ts <- list() # empty data frame to hold the time series data

# run simulations from time 1 to 500, one simulation per scenario row for as many rows as we have

for(i in 1:n){
  # read in parameters from spreadsheet
  parms <- c(beta = scen[i, c('beta')], # transmission rate
             gamma = 1/9,
             alpha = 4,
             Cp = pop[i, c('Cp')], # called back from population spreadsheet
             n1 = scen[i,c('n1')],
             n2 = scen[i, c('n2')],
             n3 = scen[i, c('n3')],
             n4 = scen[i, c('n4')],
             ef1_1 = scen[i,c('ef1_1')],
             ef1_2 = scen[i,c('ef1_2')],
             ef1_3 = scen[i,c('ef1_3')],
             ef1_4 = scen[i,c('ef1_4')],
             ef1_5 = scen[i,c('ef1_5')],
             ef4p =  scen[i,c("ef4p")], #proportion of adults over 65 social distancing at 80%
             ef2_1 = scen[i,c('ef2_1')],
             ef2_2 = scen[i,c('ef2_2')],
             ef2_3 = scen[i,c('ef2_3')],
             ef2_4 = scen[i,c('ef2_4')],
             ef3_1 = scen[i,c('ef3_1')],
             ef3_2 = scen[i,c('ef3_2')],
             ef3_3 = scen[i,c('ef3_3')],
             ef3_4 = scen[i,c('ef3_4')],
             ef4_1 = scen[i,c('ef4_1')],
             ef4_2 = scen[i,c('ef4_2')],
             ef4_3 = scen[i,c('ef4_3')],
             ef4_4 = scen[i,c('ef4_4')],
             ef1 = 0,
             ef2 = 0,
             ef3 = 0,
             ef4 = 0,
             dh1 = scen[i,c('dh1')], dh2 = scen[i,c('dh2')], dh3 = scen[i,c('dh3')],dh4 = scen[i,c('dh4')],
             dh3_2 = scen[i,c('dh3_2')],dh4_2 = scen[i,c('dh4_2')],
             dc1 = scen[i,c('dc1')], dc2 = scen[i,c('dc2')], dc3 = scen[i,c('dc3')],dc4 = scen[i,c('dc4')],
             dc3_2 = scen[i,c('dc3_2')],dc4_2 = scen[i,c('dc4_2')],
             dnh1 = scen[i,c('dnh1')], dnh2 = scen[i,c('dnh2')], dnh3 = scen[i,c('dnh3')],dnh4 = scen[i,c('dnh4')],
             hlos1 = scen[i,c('hlos1')],
             hlos2 = scen[i,c('hlos2')],
             hlos3 = scen[i,c('hlos3')],
             hlos4 = scen[i,c('hlos4')],
             clos1 = scen[i,c('clos1')],
             clos2 = scen[i,c('clos2')],
             clos3 = scen[i,c('clos3')],
             clos4 = scen[i,c('clos4')],
             hlos1a = scen[i,c('hlos1a')],
             hlos2a = scen[i,c('hlos2a')],
             hlos3a = scen[i,c('hlos3a')],
             hlos4a = scen[i,c('hlos4a')],
             clos1a = scen[i,c('clos1a')],
             clos2a = scen[i,c('clos2a')],
             clos3a = scen[i,c('clos3a')],
             clos4a = scen[i,c('clos4a')],
             dimmuneI = scen[i,c('dimmuneI')],
             dimmuneA = scen[i,c('dimmuneA')],
             vac1 = scen[i,c('vac1')], 
             vac2 = scen[i,c('vac2')],
             vac3 = scen[i,c('vac3')],
             vac4 = scen[i,c('vac4')],
             vac1a = scen[i,c('vac1a')], 
             vac2a = scen[i,c('vac2a')],
             vac3a = scen[i,c('vac3a')],
             vac4a = scen[i,c('vac4a')],
             vac1b = scen[i,c('vac1b')], 
             vac2b = scen[i,c('vac2b')],
             vac3b = scen[i,c('vac3b')],
             vac4b = scen[i,c('vac4b')],##Vaccinated number by age group (incorporates efficacy: true proportion*vEF = vac)
             vd = scen[i,c('vd')], #Duration of immunity from vaccination
             pS1 = scen[i,c('pS1')], ## proportion of infectious individuals symptomatic (0-19)
             pS2 = scen[i,c('pS2')], ## proportion of infectious individuals symptomatic (20-39)
             pS3 = scen[i,c('pS3')], ## proportion of infectious individuals symptomatic (40-64)
             pS4 = scen[i,c('pS4')], ## proportion of infectious individuals symptomatic (65+)
             #pID = scen[i,c('pID')], ## proportion of infections identified
             siI = scen[i,c('siI')],## Proportion of symptomatic individuals self isolate
             lambda = scen[i,c('lambda')], ##difference in infectiousness symptomatic/asymptomatic
             hosp1 = scen[i,c('hosp1')], 
             cc1 = scen[i,c('cc1')],
             hosp2 = scen[i,c('hosp2')], 
             hosp3 = scen[i,c('hosp3')], 
             hosp4 = scen[i,c('hosp4')], 
             cc2a = scen[i,c('cc2a')],cc2b = scen[i,c('cc2b')],cc2c = scen[i,c('cc2c')],
             cc3a = scen[i,c('cc3a')],cc3b = scen[i,c('cc3b')],cc3c = scen[i,c('cc3c')],
             cc4a = scen[i,c('cc4a')],cc4b = scen[i,c('cc4b')],cc4c = scen[i,c('cc4c')],
             mag1 = scen[i, c('mag1')],
             mag2 = scen[i, c('mag2')],
             mag2a = scen[i, c('mag2a')],
             mag3 = scen[i, c('mag3')],
             mag3a = scen[i, c('mag3a')],
             mag4 = scen[i, c('mag4')],
             mag4a = scen[i, c('mag4a')],
             mag4b = scen[i, c('mag4b')],
             mag5 = scen[i, c('mag5')],
             mag5a = scen[i, c('mag5a')],
             mag5b = scen[i, c('mag5b')],
             mag5c = scen[i, c('mag5c')],
             mag6 = scen[i, c('mag6')],
             mag6a = scen[i, c('mag6a')],
             mag6b = scen[i, c('mag6b')],
             mag6c = scen[i, c('mag6c')],
             mag7 = scen[i, c('mag7')],
             mag8 = scen[i, c('mag8')],
             mag9 = scen[i, c('mag9')],
             mag10 = scen[i, c('mag10')],
             mag11 = scen[i, c('mag11')],
             mag12 = scen[i, c('mag12')],
             mag13 = scen[i, c('mag13')],
             mag14 = scen[i, c('mag14')],
             mag15 = scen[i, c('mag15')],
             mag16 = scen[i, c('mag16')],
             mag17 = scen[i, c('mag17')],
             mag18 = scen[i, c('mag18')],
             mag19 = scen[i, c('mag19')],
             mag20 = scen[i, c('mag20')],
             traj = scen[i, c("traj")],
             t1 = scen[i,c('t1')],
             t2 = scen[i,c('t2')],
             t2a = scen[i,c('t2a')],
             t3 = scen[i,c('t3')],
             t3a = scen[i,c('t3a')],
             t4 = scen[i,c('t4')],
             t4a = scen[i,c('t4a')],
             t5 = scen[i,c('t5')],
             t5a = scen[i,c('t5a')],
             t5b = scen[i,c('t5b')],
             t6 = scen[i,c('t6')],
             t6a = scen[i,c('t6a')],
             t6b = scen[i,c('t6b')],
             t7 = scen[i,c('t7')], 
             t8 = scen[i,c('t8')],
             t9 = scen[i,c('t9')],
             t10 = scen[i,c('t10')],
             t11 = scen[i,c('t11')],
             t12 = scen[i,c('t12')],
             t13 = scen[i,c('t13')],
             t14 = scen[i,c('t14')],
             t15 = scen[i,c('t15')],
             t16 = scen[i,c('t16')],
             t17 = scen[i,c('t17')],
             t18 = scen[i,c('t18')],
             t19 = scen[i,c('t19')],
             t20 = scen[i,c('t20')],
             ttraj = scen[i,c('ttraj')],
             tvacend = scen[i,c('tvacend')],
             tproject = scen[i,c('tproject')],
             tpa = scen[i,c('tpa')],
             tpb = scen[i,c('tpb')],
             tpc = scen[i,c('tpc')],
             ramp = scen[i,c('ramp')],
             maska = scen[i,c('maska')],
             maskb = scen[i,c('maskb')],
             maskc = scen[i,c('maskc')], #proportion wearing masks for projections
             kap = scen[i,c("kap")], #average number of contacts traced per detected case
             pCT = scen[i,c("pCT")], #proportion of identified cases with contacts traced
             pi = scen[i,c("pi")], #probability a contact traced infected individual is isolated before infecting other susceptibles 
             om = scen[i,c("om")], #probability a contact traced individual is infected
             temp_on = scen[i,c("temp_on")]
  )
  
  dt      <- seq(0, 500, 1)
  
  inits      <- c(S1 = pop$n1 - 1, E1 = 0, I1 = 1, II1 = 0, Ih1 = 0, Ic1 = 0, A1 = 0, R1 = 0, RA1 = 0, Rh1 = 0, Rc1 = 0, V1 = 0, D1 = 0,
                  S2 = pop$n2,     E2 = 0, I2 = 0, II2 = 0, Ih2 = 0, Ic2 = 0, A2 = 0, R2 = 0, RA2 = 0, Rh2 = 0, Rc2 = 0, V2 = 0, D2 = 0,
                  S3 = pop$n3,     E3 = 0, I3 = 0, II3 = 0, Ih3 = 0, Ic3 = 0, A3 = 0, R3 = 0, RA3 = 0, Rh3 = 0, Rc3 = 0, V3 = 0, D3 = 0,
                  S4 = pop$n4,     E4 = 0, I4 = 0, II4 = 0, Ih4 = 0, Ic4 = 0, A4 = 0, R4 = 0, RA4 = 0, Rh4 = 0, Rc4 = 0, V4 = 0, D4 = 0)
  N  <- pop$Cp
  
  
  out <- lsoda(inits, dt, seir1, parms = parms)
  covid_ts[[i]] <- as.matrix(out)
}

#library(dplyr)
all <-  as.data.frame(cbind(rep(1:n, each=501), do.call("rbind", covid_ts)))
all$scenario <- all$V1
all$V1 <- NULL

all.scen <- merge(scen, all, by = "scenario")

#all.scen.temp <- merge(all.scen, temp, by = "time")

# create incrementing date vector of length 500 for all scenarios

all.scen$date <- seq(from = as.Date("2020/1/24"), to = as.Date("2020/1/24") + 500, "days")

write.csv(all.scen, './scen20210125.csv', row.names = F)
