pro make_xrttresp_forpy

  ; Make and save out some Hinode/XRT temeprature response functions to play about with in python
  ;
  ; 28-Oct-2020 IGH
  ;
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  dates=['28-Sep-2018','12-Jan-2019','25-Apr-2019','02-Jul-2019','21-Feb-2020','12-Sep-2020']
  nd=n_elements(dates)
  
  for d=0, nd-1 do begin
    wave_resp = make_xrt_wave_resp(contam_time=dates[d])
    xrt_tresp = make_xrt_temp_resp(wave_resp, /apec_default)
    
    print,wave_resp[1].contam.thick_time,wave_resp[1].contam.thick
    ; For this only need 'Al-poly', 'Be-thin'
    filts=xrt_tresp.name
    for f=0, n_elements(filts)-1 do begin
      idf=strpos(filts[f],';')
      filts[f]=strmid(filts[f],0,idf)
    endfor
    id1=where(filts eq 'Al-poly')
    id2=where(filts eq 'Be-thin')
    ids=[id1,id2]
    filters=filts[ids]
   
    print,xrt_tresp[ids].name
    units=xrt_tresp[ids[0]].temp_resp_units
    gd=where(xrt_tresp[ids[0]].temp gt 0.0)
    logt=alog10(xrt_tresp[ids[0]].temp[gd])
    tr=xrt_tresp[ids].temp_resp[gd]
    
    date=anytim(dates[d],/ccsds)
;    print,xrt_tresp[0].contam.thick_time
    
    save,file='xrt_tresp_'+strmid(break_time(dates[d]),0,8)+'.dat',filters,logt,tr,units,date
    
;    stop
  endfor

  stop
end