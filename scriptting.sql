-- Documentation : Case Study 
/*
Step 1: creating of database
step 2 : Exploration of database:
			missing values are present between 
				movie,
                names,
                role_mapping,
                ratings
Step 2.2: Understanding Descriptive Stats
			Check Mean, median for numerical values
            mode for categorical values
            maximum, minimum
	2.3: outlier detection (excessive values) : As such extreme values are present 
		within movie use median
        for eg: 1,2,3,4,5 --> mean 3 median 3
				1,2,3,4,10 --> mean 4 median 3
		if excessive values are present then use median
        
Descriptive Stats : Mean and median - numerical

Step 3: data processing/Data cleaning:-
		1: Handling of missing values::
			1 check whether the column numerical or categorical.
            2 if number missing values are greater than >25% OF THE Data and the column can
					 be removed according to domain knowledge remove the column
			3. if column is important and cannot be ommited then cap the values 
            and the missing values percentage >25% then we have to canp the values
			4. <25% then definetly cap the values
            
            -- cap the values logic:-
				 1. Substituting values with related information from data
                 2. 
            








*/