
# Basic rules #

  * The most important: **EVERY BUG MUST BE REPORTED IN THE ISSUES PAGE**. By doing this, another users will be aware of the bug and one of the developers can fix it.

  * The **only official source** of the toolbox is the **download** section of Google code. **Do not** copy the files from another person/source, because it may have been altered.

  * If a user fixes a bug in the toolbox, the modified code shall be posted in the issues area, as reply/comment to the corresponding bug. A developer will check the code and, if everything is fine, modify the code and release a new version. **Do not** provide these modifications for another users.

  * Do not create **multiple** versions of the **same** operations for different situations. Each piece of code must be as generic as possible. Code redundancy increases the effort of code maintenance.

  * **Modified code => You are on your own.**

---

# Bug reporting/Suggest functionality guidelines #
  * Provide all relevant files. These files can be uploaded in the Issues section.
  * Provide detailed information about the actions taken leading to the bug and its result. The pattern provided by Google code is a very good way to do this.
  * Save storage by using small file formats. **Do not** upload BMP files. Use .png ou .jpg instead. **Do not** upload .doc files, prefer .pdf or .txt files.
  * Details **are** relevant. When suggest new functionalities (or improvements on existing ones), provide as much information as possible.


---

# Coding guidelines #

  * The code must be well commented, with all relevant information. Example:
```
% x = K[R|T]X
% K^{-1} x = [R | T]X
for i=1:tam
  Ll(i,:)=(Ki*Ll(i,:)')';
end
(...)
% proper normalization, using the norm of one of the rotation vectors
RT=RT*1/sqrt(sum(RT(9:11).^2));
```

  * Every function must have the his behavior (input/output) detailed in the first lines of the code, making possible the use of "help command". Example:
```
function filename=pick(extension)
%function filename=pick(extension)
% Graphical interface to pick files in the current directory with
% the given extension:
% pick('avi') -> list all avi files
% pick without arguments means all files
% 
```

  * The code must not contain fixed numbers or filenames. Only exception at this moment is for temporary calibration files(temp\_aux.clb), used (and deleted) in the calibration step. Define variables or function parameters for numbers/filenames (use pick function!). Example:
```
%Do not
for i=1:12
    L(il,:)=[unico(i) unico(i+1)];
end
```
```
%Do
num_parameters=12;
(...)
for i=1:num_parameters
    L(il,:)=[unico(i) unico(i+1)];
end
```

  * Every function used in the toolbox, but not related with calibration (like the pick function) shall be placed in the _etc_ directory.
  * Every function copied from another toolbox/source must be placed in the _lib_ directory, its copyright and author information **must** be maintained and the author **must** be cited in the homepage of the toolbox. Of course, **do not** use code without authorization from the corresponding authors.