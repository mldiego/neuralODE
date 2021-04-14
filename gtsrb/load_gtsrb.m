function [testset,labels] = load_gtsrb()
    data_folder = "/home/manzand/Documents/MATLAB/NeuralODEs/gtsrb/data/GTSRB/testset/";
    file_to_read = data_folder + "test.csv";
    csvfile = importdata(file_to_read);
    labels = csvfile.data;
    testset = zeros(32,32,3,12630);
    im_mean = [0.3403, 0.3121, 0.3214];
    im_std = [0.2724, 0.2608, 0.2669];
    for i=2:12631
        try
            im_temp = double(imread(data_folder + string(csvfile.textdata{i})));
            im_temp = imresize(im_temp,[32 32]);
            im_temp = im_temp./255;
            for c =1:3
                im_temp(:,:,c) = (im_temp(:,:,c) - im_mean(c))/im_std(c);
            end
            testset(:,:,:,i) = im_temp;
        catch
            warning("Image "+string(csvfile.textdata{i})+" failed to load")
        end
    end
end

