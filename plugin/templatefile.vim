" load template file for new files
au BufNewFile * silent call LoadTemplateFile ()

" template file loaded
function! LoadTemplateFile ()
	let extension = expand ("%:e")
	if extension == ""
		let template_file = $VIMTEMPLATE . "/skel.noext." . expand ("%:t")
		let template_func = "TemplateFileFunc_noext_" . expand ("%:t")
	else
		let template_file = $VIMTEMPLATE . "/skel." . extension
		let template_func = "TemplateFileFunc_" . extension
	endif
  if filereadable (template_file)
    execute "0r " template_file
    let date = strftime ("%c")
    let year = strftime ("%Y")
    let cwd = getcwd ()
    let lastdir = substitute (cwd, ".*/", "", "g")
    let myfile = expand ("%")
    let inc_gaurd = substitute (myfile, "\\.", "_", "g")
    let inc_gaurd = toupper (inc_gaurd)
    let inc_gaurd = "INC_" . inc_gaurd . "_"
    silent! execute "%s/@DATE@/" .  date . "/g"
    silent! execute "%s/@YEAR@/" .  year . "/g"
    silent! execute "%s/@LASTDIR@/" .  lastdir . "/g"
    silent! execute "%s/@FILE@/" .  myfile . "/g"
    silent! execute "%s/@INCLUDE_GAURD@/" . inc_gaurd . "/g"
  endif
	if exists ("*" . template_func)
		echo "calling " . template_func
		exec (":call " . template_func . "()")
	endif
endfunction

" example for extension file specific template processing
function TemplateFileFunc_c ()
	let save_r = @r
	let @r = "int main (int argc, char ** argv)\n{\n\treturn 0;\n}\n"
	normal G
	put r
	let @r = save_r
endfunction

" example for no-extension file specific template processing
function! TemplateFileFunc_noext_makefile ()
	let save_r = @r
	let @r = "all:\n\techo your template files need work"
	normal G
	put r
	let @r = save_r
endfunction

