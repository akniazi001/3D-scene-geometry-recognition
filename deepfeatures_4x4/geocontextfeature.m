function Geof= geocontextfeature(patch, F , feature_path,i)
%% color features 
                         features=[];

                        [h s v]=rgb2hsv(patch); % hsv values
                        R=mean(mean(patch(:,:,1))); % means of R,G and B  
                        G=mean(mean(patch(:,:,2)));
                        B=mean(mean(patch(:,:,3)));
                        %%hsv feature
                        H=mean(mean(h)); 
                       
                        S= mean(mean(s));
                        V= mean(mean(v)); 
                        %% hue bin =5
                        hu=histogram(h,5);  he= entropy(h); 
                        sat= histogram(s,3);  se= entropy(s);
                      %  dG = filterDoog( dims, sigmas, nderivs, show );
                      %   dG = filterDoog( [3 3], [0.5 0.5], [1 1], [0] );                  
                      %    doog= imfilter(patch, dG, 'conv');
                        %% 

                        nAngles=12;
                        for (i=1:nAngles)        
                            orientationImages(:, :, i) = abs(conv2(patch,doogFilters(:, :, i),'same')-patch);        
                         end
                       features(:, 1:nAngles) = maar;
    features(:, nAngles+1) = mean(maar, 2);
    [maxval, features(:, nAngles+2)] = max(maar, [], 2);
    features(:, nAngles+3) = maxval - median(maar, 2);    
    spdata(i).orientation = maar;
    spdata(i).edginess = mean(orientationImages, 3); 
 

%         [polyi, polya] = convhull(rx, ry);
%         regionFeatures(c, nf+19) = length(polyi)-1;
%         regionFeatures(c, nf+20) = npix / (polya*width*height);
         nf = nf + 21;
    region_center = [sorty(ceil(npix/2)) sortx(ceil(npix/2))];  

    rbounds = [sortx(1) sortx(end) 1-sorty(end) 1-sorty(1)];
    regionFeatures(c, nf+(1:16)) = ...
        APPvp2regionFeatures(spind, vpdata, region_center, rbounds, imsegs);

    % y-location with respect to estimated horizon
    if ~isnan(vpdata.hpos)
        % location - 10% and 90% percentiles of y and x
        regionFeatures(c, nf+17) = regionFeatures(c, 48) - (1-vpdata.hpos); % bottom 10 pct wrt horizon
        regionFeatures(c, nf+18) = regionFeatures(c, 49) - (1-vpdata.hpos); % top 10 pct wrt horizon
        % 1 -> completely under horizon, 2-> straddles horizon, 3-> completely above horizon
        regionFeatures(c, nf+19) = (regionFeatures(c, nf+20)>0) + (regionFeatures(c, nf+21)>0) + 1;
    else % horizon was not estimated with high confidence
        regionFeatures(c, nf+(17:18)) = regionFeatures(c, [48:49])-0.5;
        regionFeatures(c, nf+19) = 4;  % signifies no data-estimated horizon
    end
    
    [h w] = size(image);
    region_center(1) = region_center(1) - 0.5;
    region_center(2) = region_center(2) - 0.5;    
    regionFeatures(c, nf+(20:38)) = ...
        APPgetVpFeatures(vpdata.spinfo(spind), vpdata.lines, region_center, [h w]);    
      
        
        
        

end