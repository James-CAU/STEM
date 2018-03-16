
  
  calc <- tibble('s'=c('a','a','b'), 't'=c('b','c','c'), 'v'=c(2,5,2))
  
  colnames(calc) <- c('source', 'target', 'value')
  
  source_freq <- calc %>%
    group_by(source) %>%
    summarise(source_f = sum(value))
  
  target_freq <- calc %>%
    group_by(target) %>%
    summarise(target_f = sum(value))
  
  merge <- merge(calc,source_freq) %>%
    merge(target_freq) %>%
     
    transform(proportion_source = value/source_f) %>%
      transform(proportion_source = round(proportion_source, digits=2)) %>%
    
     transform(proportion_target = value/target_f)%>%
       transform(proportion_target = round(proportion_target, digits=2)) %>%
    
    subset(select = c(source, target, value, proportion_source, proportion_target, source_f, target_f))


  
