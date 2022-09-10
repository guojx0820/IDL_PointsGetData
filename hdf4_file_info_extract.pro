pro hdf4_file_info_extract
  modis_data='D:/Experiments/AOD_Retrieval/DATA/MOD04_3K/MOD04_3K.A2022232.0150.061.2022234184507.hdf'
  sd_id=hdf_sd_start(modis_data,/read)
  hdf_sd_fileinfo,sd_id,sds_num,att_num
  print,sds_num,att_num
  for sds_i=0,sds_num-1 do begin
    sds_id=hdf_sd_select(sd_id,sds_i)
    hdf_sd_getinfo,sds_id,name=sds_name,natts=sds_att_num
    print,'The sds_name of '+strcompress(string(sds_i))+' is:'
    print,sds_name
    print,'The included attribute name:'
    if sds_att_num gt 0 then begin
      for att_i=0,sds_att_num-1 do begin
        hdf_sd_attrinfo,sds_id,att_i,name=sds_att_name,data=sds_data_info
        print,sds_att_name+':'+strcompress(string(sds_data_info))
      endfor
      print,string('**************************************')
    endif
    hdf_sd_endaccess,sds_id
  endfor
  
  for att_i=0,att_num-1 do begin
    hdf_sd_attrinfo,sd_id,att_i,name=global_att_name,data=global_data_info
    print,'global_att_name:'
    print,global_att_name+':'+strcompress(string(global_data_info))
  endfor
  hdf_sd_end,sd_id
end