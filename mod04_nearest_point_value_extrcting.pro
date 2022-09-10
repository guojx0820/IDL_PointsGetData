function hdf4_data_get,file_name,sds_name
  sd_id=hdf_sd_start(file_name,/read)
  sds_index=hdf_sd_nametoindex(sd_id,sds_name)
  sds_id=hdf_sd_select(sd_id,sds_index)
  hdf_sd_getdata,sds_id,data
  hdf_sd_endaccess,sds_id
  return,data
end

function hdf4_attdata_get,file_name,sds_name,att_name
  sd_id=hdf_sd_start(file_name,/read)
  sds_index=hdf_sd_nametoindex(sd_id,sds_name)
  sds_id=hdf_sd_select(sd_id,sds_index)
  att_index=hdf_sd_attrfind(sds_id,att_name)
  hdf_sd_attrinfo,sds_id,att_index,data=att_data
  hdf_sd_endaccess,sds_id
  hdf_sd_end,sd_id
  return,att_data
end

pro mod04_nearest_point_value_extrcting
  extract_lon=120.00  
  extract_lat=20.00
  extract_lon_zj=120.00
  extract_lat_zj=29.00
  extract_lon_fj=118.00
  extract_lat_fj=25.00
  point_name='Taiwan'
  point_name_zj='Zhejiang'
  point_name_fj='Fujian'
  data_path='D:\Experiments\AOD_Retrieval\DATA\MOD04_3K'
  file_list=file_search(data_path,'*.hdf')
  file_n=n_elements(file_list)
  out_file=data_path+'point_value_'+point_name+'.txt'
  out_file_zj=data_path+'point_value_'+point_name_zj+'.txt'
  out_file_fj=data_path+'point_value_'+point_name_fj+'.txt'
  openw,1,out_file
  openw,2,out_file_zj
  openw,3,out_file_fj
  
  for file_i=0,file_n-1 do begin
    out_date=strmid(file_basename(file_list[file_i]),10,7)
    date=fix(strmid(file_basename(file_list[file_i]),14,3))
    out_year=strmid(file_basename(file_list[file_i]),10,4)
    out_year_fix=fix(strmid(file_basename(file_list[file_i]),10,4))
    date_julian=imsl_datetodays(31,12,out_year_fix-1);imsl相关的函数说明在ENVI安装目录help中的pdf中：advmathstats.pdf
    imsl_daystodate,date_julian+date,day,month,year;将儒略日转化为日期
    out_month=month
    out_day=day
    
    modis_lon_data=hdf4_data_get(file_list[file_i],'Longitude')
    modis_lat_data=hdf4_data_get(file_list[file_i],'Latitude')
    modis_aod_data=hdf4_data_get(file_list[file_i],'Image_Optical_Depth_Land_And_Ocean')
    scale_factor=hdf4_attdata_get(file_list[file_i],'Image_Optical_Depth_Land_And_Ocean','scale_factor')
    fill_value=hdf4_attdata_get(file_list[file_i],'Image_Optical_Depth_Land_And_Ocean','_FillValue')
    modis_aod_data=(modis_aod_data ne fill_value[0])*modis_aod_data*scale_factor[0]
    
    x=(modis_lon_data-extract_lon)
    y=(modis_lat_data-extract_lat)
    x_zj=(modis_lon_data-extract_lon_zj)
    y_zj=(modis_lat_data-extract_lat_zj)
    x_fj=(modis_lon_data-extract_lon_fj)
    y_fj=(modis_lat_data-extract_lat_fj)
    distance=sqrt(x^2+y^2)
    distance_zj=sqrt(x_zj^2+y_zj^2)
    distance_fj=sqrt(x_fj^2+y_fj^2)
    ;pos01=where(distance lt 0.1)
    ;extract_aod01=modis_aod_data[pos01]
    ;n_pos=n_elements(pos01)
    ;for i_pos=0,n_pos-1 do begin
    ;  printf,1,out_year,out_month,out_day,modis_lon_data[pos01[i_pos]],modis_lat_data[pos01[i_pos]],extract_aod01[i_pos],format='(I0,"/",I02,"/",I02,",",3(F0.3,:,","))'
    ;endfor
    

    min_dis=min(distance)
    min_dis_zj=min(distance_zj)
    min_dis_fj=min(distance_fj)
    pos=where(distance eq min_dis)
    pos_zj=where(distance_zj eq min_dis_zj)
    pos_fj=where(distance_fj eq min_dis_fj)
    extract_aod=modis_aod_data[pos]
    extract_aod_zj=modis_aod_data[pos_zj]
    extract_aod_fj=modis_aod_data[pos_fj]
    if extract_aod gt 0.0 then begin
      ;print,out_date,string([modis_lon_data[pos],modis_lat_data[pos],extract_aod])
      ;print,out_date,[modis_lon_data[pos],modis_lat_data[pos],extract_aod],format='(A,",",3(F0.3,:,","))'
      printf,1,out_year,out_month,out_day,modis_lon_data[pos],modis_lat_data[pos],extract_aod,format='(I0,"/",I02,"/",I02,",",3(F0.3,:,","))'
    endif
    if extract_aod_zj gt 0.0 then begin
      printf,2,out_year,out_month,out_day,modis_lon_data[pos_zj],modis_lat_data[pos_zj],extract_aod_zj,format='(I0,"/",I02,"/",I02,",",3(F0.3,:,","))'
    endif
    if extract_aod_fj gt 0.0 then begin
      printf,3,out_year,out_month,out_day,modis_lon_data[pos_fj],modis_lat_data[pos_fj],extract_aod_fj,format='(I0,"/",I02,"/",I02,",",3(F0.3,:,","))'
    endif

  endfor 
  free_lun,1
  free_lun,2
  free_lun,3
  
end