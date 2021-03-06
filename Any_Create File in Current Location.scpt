JsOsaDAS1.001.00bplist00�Vscript_9app = Application.currentApplication();
app.includeStandardAdditions = true;

ObjC.import("Cocoa");

function path_dirname(p) {
	var a = p.split('/');
	a.pop();
	var rv = a.join('/');
	if (!rv) return "/";
	else return rv;
}

function path_basename(p) {
	var a = p.split('/');
	if (a.length > 1) return a.pop();
	else return p;
}

function path_basename_ext(p) {
	var n = path_basename(p);
	var x = n.lastIndexOf('.');
	if (x > 0) return n.substr(x+1);
	else return "";
}

function path_basename_noext(p) {
	var n = path_basename(p);
	var x = n.lastIndexOf('.');
	if (x > 0) return n.substr(0, x);
	else return n;
}

function path_is_package(p) {
	return $.NSWorkspace.sharedWorkspace.isFilePackageAtPath(p);
}

function file_exists(p) {
	var isdir = Ref();
	var rv = $.NSFileManager.defaultManager.fileExistsAtPathIsDirectory(p, isdir);

	return (!isdir[0] && rv);
}

function directory_exists(p) {
	var isdir = Ref();
	var rv = $.NSFileManager.defaultManager.fileExistsAtPathIsDirectory(p, isdir);
	return (isdir[0] && rv);
}

function path_exists(p) {
	var isdir = false;
	var rv = $.NSFileManager.defaultManager.fileExistsAtPathIsDirectory(p, isdir);
	return rv;
}

function URL2Path(u) {
	var u = $.NSURL.alloc.initWithString(u);
	return ObjC.unwrap(u.path);
}

function run() {
  sys = Application("System Events");
  proc = sys.processes.whose({frontmost: true})[0];

  if (proc.name() === "Finder") {
    finder = Application("Finder");
    url = finder.insertionLocation().url();//finder.windows[0].target().url();
	path = URL2Path(url);
  }
  else {
    bm = Application("BookMarkable");
    bm.bookmarkForemostApplication({hidePanel:true});

    while (bm.working()) {
      delay(0.1);
    }

    url = bm.currentUrl();
	path = bm.currentPath();
	if (!path && url && url.indexOf("terminal-") === 0) {
	  path = URL2Path(url);
	}
  }
  
  if (path) {
  	if(file_exists(path) || path_is_package(path)) path = path_dirname(path);
  
  	tx = Application("TextSer");
  	tx.createFromTemplate({destination:Path(path)});
  }
  else {
  	tx = Application("TextSer");
  	tx.createFromTemplate();
  }
}
                              O jscr  ��ޭ