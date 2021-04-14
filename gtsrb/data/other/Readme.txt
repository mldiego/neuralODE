**********************************************

The German Traffic Sign Recognition Benchmark

Example code for MATLAB

**********************************************

This archive contains example code for MATLAB for 
reading the datasets and corresponding annotations.
It contains the following files:

    Readme.txt           - This file
    TrainTrafficSigns.m  - Functions to read the training dataset
    EvalTrafficSigns.m   - Functions to read the test dataset

Both files need to be adjusted to your needs in a few spots. 
These lines are marked with "TODO".

**********************************************
TrainTrafficSigns.m 
**********************************************

The file TrainTrafficSigns.m provides the following functions:
    TrainTrafficSigns()   - This function iterates the training dataset
                            successivly reads all images and annotations
                            and calls MyTrainingFunction for each.

    readSignData( aFile ) - Helper function used by TrainTrafficSigns 
                            to read an image and the corresponding annotations

    MyTrainingFunction(aImg, aClasses)
                          - Dummy function. You can implement your training here.


**********************************************
EvalTrafficSigns.m 
**********************************************

The file EvalTrafficSigns.m provides the following functions:
    EvalTrafficSigns()    - This function iterates the training dataset
                            successivly reads all images and annotations
                            and calls MyClassificationFunctionfor each.
                            The classification results are written to 
			    "classification_results.csv" in the correct format.
			
    readSignData( aFile ) - Helper function used by EvalTrafficSigns
                            to read an image and the corresponding annotations

    MyClassificationFunction(aImg)(aImg, aClasses)
                          - Dummy function. Call your classifier here.



**********************************************
Further information
**********************************************
For more information on the competition procedures and to obtain the test set, 
please visit the competition website at

	http://benchmark.ini.rub.de

If you have any questions, do not hesitate to contact us 
    
	tsr-benchmark@ini.rub.de


**********************************************
Institut für Neuroinformatik
Real-time computer vision research group

Ruhr-Universität Bochum
Germany
**********************************************