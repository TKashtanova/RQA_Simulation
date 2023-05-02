% Create definition files of two heterogeneous phantoms
% Output: 
%       density.img and matimage.img files
%       
% by Samuel Ydenberg

% In a cube-shaped water phantom with a side length of 30 cm, 
% the bone cubical piece is located between 5 cm and 10 cm from the phantom top.
% The air cubical piece is located between 15 cm and 20 cm from the phantom top.

% Phantom side length in voxels
ph_size = 150;
% Bone/Air cube side length in voxels
cube_size = 50;
% Position of the bone/air cube central voxel
start_pos = (ph_size - cube_size) / 2;
% Type of material (0 for water, 2 for bone, 4 for air)
material2 = 2;
material4 = 4;
% Material density
dens_material2 = 1.85;
dens_material4 = 1.20480E-03;

% Create matimage.img file 
matim = zeros(ph_size,ph_size,ph_size); 

% To have both the bone and air pieces in the water phantom,
% uncomment the lines in the third "for" loop.
for i = 1:cube_size
    for j = 1:cube_size
        for k = 1:cube_size
           % if j <= cube_size/2
                matim(i+start_pos,j+25,k+start_pos) = material2;
           % else
                %matim(i+start_pos,j,k+start_pos) = material4;
            %end
        end
    end
end

new_dens_path = strcat('./matimage.img');
fid1  = fopen(new_dens_path,'w+');
fwrite(fid1,matim,'int32');
fclose(fid1);

% Test matimage.img file
dens_path = strcat('./matimage.img');
fid2  = fopen(dens_path);
data_new = fread(fid2,'int32');
fclose(fid2);
inds1 = find(data_new >= (material2 - .01));

% Create density.img file 
% Density of water = 1
dens = ones(ph_size,ph_size,ph_size); 

% To have both the bone and air pieces in the water phantom,
% uncomment the lines in the third "for" loop.
for i = 1:cube_size
    for j = 1:cube_size
        for k = 1:cube_size
            %if j <= cube_size/2
                dens(i+start_pos,j+25,k+start_pos) = dens_material2;
           % else
                %dens(i+start_pos,j+start_pos,k+start_pos) = dens_material4;
           % end
        end
    end
end

new_dens_path2 = strcat('./density.img');
fid3  = fopen(new_dens_path2,'w+');
fwrite(fid3,dens,'single');
fclose(fid3);

% Test density.img file 
dens_path2 = strcat('./density.img');
fid4  = fopen(dens_path2);
data_new2 = fread(fid4,'single');
fclose(fid4);
inds2 = find(data_new2 >= (dens_material2 - 0.01));
