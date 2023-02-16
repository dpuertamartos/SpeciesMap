import dask.dataframe as dd

##Change country code to select which country to filter

multimedia_dataframe_path = 'E://biodiversity-data/multimedia.csv'
filtered_dataframe_path = 'E://biodiversity-data/filteredPoland.csv'

joined_dataframe_path_to_write = 'E://biodiversity-data/filteredPolandMultimedia.csv'

##Giving dtype for habit and samplitProtocol speed up the dataframe processing
df_multimedia = dd.read_csv(multimedia_dataframe_path)
df_filtered = dd.read_csv(filtered_dataframe_path, dtype={'habitat': 'object',
       'samplingProtocol': 'object'})

#outer join of df to keep multimedia info
df_merged = dd.merge(df_filtered, df_multimedia, left_on="id", right_on="CoreId", how="left")

df_merged.to_csv(joined_dataframe_path_to_write, single_file=True, index=False)