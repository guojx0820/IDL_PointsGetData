pro hdf4_dataset_read
  file_name='D:\Experiments\AOD_Retrieval\DATA\MOD04_3K\MOD04_3K.A2022232.0150.061.2022234184507.hdf'
  result_name='D:\Experiments\AOD_Retrieval\DATA\MOD04_3K\MOD04Extraction\MOD04_3K.A2022232.0150.061.2022234184507.tiff'
  modis_sd_id=hdf_sd_start(file_name,/read)
  modis_sds='Longitude'
  modis_sds_index=hdf_sd_nametoindex(modis_sd_id,modis_sds)
  modis_sds_id=hdf_sd_select(modis_sd_id,modis_sds_index)
  hdf_sd_getdata,modis_sds_id,modis_lon_data
  ;print,modis_sds_id,modis_lon_data
  
  modis_sds='Latitude'
  modis_sds_index=hdf_sd_nametoindex(modis_sd_id,modis_sds)
  modis_sds_id=hdf_sd_select(modis_sd_id,modis_sds_index)
  hdf_sd_getdata,modis_sds_id,modis_lat_data
  ;print,modis_lon_data
  
  modis_sds='Image_Optical_Depth_Land_And_Ocean'
  modis_sds_index=hdf_sd_nametoindex(modis_sd_id,modis_sds)
  modis_sds_id=hdf_sd_select(modis_sd_id,modis_sds_index)
  hdf_sd_getdata,modis_sds_id,modis_target_data
  print,size(modis_target_data)
  
  modis_att_index=hdf_sd_attrfind(modis_sds_id,'scale_factor')
  hdf_sd_attrinfo,modis_sds_id,modis_att_index,data=sf 
  modis_att_index=hdf_sd_attrfind(modis_sds_id,'_FillValue')
  hdf_sd_attrinfo,modis_sds_id,modis_att_index,data=fv
  print,sf,fv
  
  hdf_sd_endaccess,modis_sds_id
  hdf_sd_end,modis_sd_id
  
  modis_target_data=(modis_target_data ne fv[0])*modis_target_data*sf[0]
  write_tiff,result_name,modis_target_data,/float
end