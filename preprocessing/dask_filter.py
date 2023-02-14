import dask.dataframe as dd

##Change country code to select which country to filter
country_to_filter = "ES"
original_dataframe_path = 'E://biodiversity-data/occurence.csv'
filtered_dataframe_path_to_write = 'E://biodiversity-data/filteredSpain.csv'

##Giving dtype for habit and samplitProtocol speed up the dataframe processing
df = dd.read_csv(original_dataframe_path,dtype={'habitat': 'object',
       'samplingProtocol': 'object'})

#filter dataframe using column countryCode
filtered_df = df[df['countryCode'] == country_to_filter]

#store filtered dataframe as a single file
filtered_df.to_csv(filtered_dataframe_path_to_write, single_file=True, index=False)
