
function flip_rotate(original_fn, flipped_fn, old_RGB, tolerance, preferredForm)

   if ~exist('original_fn','var') | ~exist('flipped_fn','var')
      error('Usage: flip_lr(original_fn, flipped_fn, [old_RGB],[tolerance])');
   end

   if ~exist('old_RGB','var') | isempty(old_RGB)
      old_RGB = 0;
   end

   if ~exist('tolerance','var') | isempty(tolerance)
      tolerance = 0.1;
   end

   if ~exist('preferredForm','var') | isempty(preferredForm)
      preferredForm= 's';				% Jeff
   end

   nii = load_nii(original_fn, [], [], [], [], old_RGB, tolerance, preferredForm);
   M = diag(nii.hdr.dime.pixdim(2:5));
   M(1:3,4) = -M(1:3,1:3)*(nii.hdr.hist.originator(1:3)-1)';
   M(1,:) = -1*M(1,:);
   M(2,:) = -1*M(2,:);
   nii.hdr.hist.sform_code = 1;
   nii.hdr.hist.srow_x = M(1,:);
   nii.hdr.hist.srow_y = M(2,:);
   nii.hdr.hist.srow_z = M(3,:);
   save_nii(nii, flipped_fn);

   return;					% flip_lr
