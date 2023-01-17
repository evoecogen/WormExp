function analysisSubmit(form)
{
   var tit = (new Date()).toString();
   var wnd = window.open("", tit, "width=800, height=620, toolbar=yes, menubar=yes, resizable=yes, scrollbars=yes");
   form.target=tit;
   wnd.focus();
   return;
}
function openWindow()
{
   var wnd = window.open("ShowID.do", "", "width=800, height=620, toolbar=yes, menubar=yes, resizable=yes, scrollbars=yes");
		wnd.focus();
	return;
}
function openManual()
{
   var wnd = window.open("manual.do", "", "width=800, height=620, toolbar=yes, menubar=yes, resizable=yes, scrollbars=yes");
		wnd.focus();
	return;
}