# LC3B_Tandem_Puncta_Quantification
The script is designed to quantify autophagic vacuoles in high resolution volumes on the single cell level.

LC3B_Tandem_Puncta_QuantificationV2 is a batch processing function used to identify LC3B vacuoles labeled with eGFP and mCherry signals and is designed for researchers investigating autophagy. Code expects the users data to be grayscale 16-bit volume data either in the form of multidimensional tiff stacks or ND2 files with three channels corresponding to the eGFP, mCherry and nuclear marker for mammalian cells. Data used to test this function was acquired using a confocal microscope as out-of-focus light will introduce issues with segmentation and other modes of image acquisition that do not minimize out-of-focus light will not produce quality results. 

Data for single cell analysis is reported as the number of eGFP and mCherry vacuoles counted for each cell and is printed to the command window along with the fileName the data was extracted from and the cellindex corresponding to which cell the vacuoles were found in with respect to the image used. This data is returned as a table to the command window and can also be viewed by calling or opening the structure Results_Table. 

NOTE: Each cell line is different and each optical system is as well. Users should experimentally determine the parameters to use for their data. A helper function is provided with the code to help users access and identify parameters for their data called  VolumeThresholdhelper. 

Users can use MATLABs publishing option to capture the outputs (recommended) for all figures created by the function or place a waitfor() call after each figure to observe the results of each figure created as the processing is occuring. See MATLABs documentation for publishing options and using watifor(). See github account for examples of the published outputs using the batchprocessing function LC3B_Tandem_Puncta_QuantificationV2 and VolumeThresholdhelper.
