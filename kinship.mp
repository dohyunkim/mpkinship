% kinship diagram for anthropology
%  written by Dohyun Kim <nomos at ktug org>
%  version: alpha state
%  license: public domain

numeric nodesize; nodesize := 1cm;

path unittriangle;
unittriangle = (dir90 -- dir210 -- dir330 -- cycle) scaled 2/3;

vardef male@#(text col_) =
  pair @#c, @#n, @#s, @#w, @#e, @#sw, @#se, @#nw, @#ne, @#cg;
  @#cg = (0,-1) scaled 1/6nodesize shifted @#c; % center of gravity
  @#n  = dir 90 scaled 2/3nodesize shifted @#cg;
  @#sw = dir210 scaled 2/3nodesize shifted @#cg;
  @#se = dir330 scaled 2/3nodesize shifted @#cg;
  @#nw = @#n; @#ne = @#n;
  @#s  = 1/2[@#se,@#sw];
  @#w  = 1/2[@#n, @#sw];
  @#e  = 1/2[@#n, @#se];
  string _fm_@#; _fm_@# :=
    "fill unittriangle scaled "&decimal nodesize &" shifted "&str @#
    &".cg withcolor "&str col_ &";draw unittriangle scaled "&decimal nodesize
    &" shifted "&str @# &".cg;";
enddef;

vardef female@#(text col_) =
  pair @#c, @#n, @#s, @#w, @#e, @#sw, @#se, @#nw, @#ne, @#cg;
  @#e  = dir  0 scaled 1/2nodesize shifted @#c;
  @#ne = dir 45 scaled 1/2nodesize shifted @#c;
  @#n  = dir 90 scaled 1/2nodesize shifted @#c;
  @#nw = dir135 scaled 1/2nodesize shifted @#c;
  @#w  = dir180 scaled 1/2nodesize shifted @#c;
  @#sw = dir225 scaled 1/2nodesize shifted @#c;
  @#s  = dir270 scaled 1/2nodesize shifted @#c;
  @#se = dir315 scaled 1/2nodesize shifted @#c;
  @#cg = @#c;
  string _fm_@#; _fm_@# :=
    "fill fullcircle scaled "&decimal nodesize &" shifted "&str @#
    &".c withcolor "&str col_ &";draw fullcircle scaled "&decimal nodesize
    &" shifted "&str @# &".c;";
enddef;

vardef unidentified@#(text col_) =
  pair @#c, @#n, @#s, @#w, @#e, @#sw, @#se, @#nw, @#ne, @#cg;
  @#ne = ( 1, 1) scaled 1/2nodesize shifted @#c;
  @#nw = (-1, 1) scaled 1/2nodesize shifted @#c;
  @#sw = (-1,-1) scaled 1/2nodesize shifted @#c;
  @#se = ( 1,-1) scaled 1/2nodesize shifted @#c;
  @#n  = 1/2[@#nw, @#ne];
  @#s  = 1/2[@#sw, @#se];
  @#e  = 1/2[@#ne, @#se];
  @#w  = 1/2[@#nw, @#sw];
  @#cg = @#c;
  string _fm_@#; _fm_@# :=
    "fill unitsquare scaled "&decimal nodesize &" shifted "&str @#
    &".sw withcolor "&str col_ &";draw unitsquare scaled "&decimal nodesize
    &" shifted "&str @# &".sw;";
enddef;

def fixmemberpos(text $$) =
  forsuffixes $ = $$:
    if unknown $c: $c = origin; fi
  endfor
enddef;

def drawmembers(text $$) =
  fixmemberpos($$);
  forsuffixes $ = $$: scantokens _fm_$; endfor
enddef;

vardef linktochildren(suffix pp_)(text $$) text _rem_ =
  fixmemberpos(pp_,$$);
  save ymid_; numeric ymid_;
  ymid_ := ypart pp_.c - nodesize;
  draw (pp_.s -- (xpart pp_.s, ymid_)) _rem_;
  forsuffixes $ = $$:
    draw ((xpart pp_.s, ymid_)--(xpart $n, ymid_)--$n) _rem_;
  endfor
enddef;
def linktochild = linktochildren enddef;

vardef linkmarriage(suffix hh_, ww_) text _rem_ =
  fixmemberpos(hh_,ww_);
  save pp_, qq_; pair pp_, qq_;
  if (xpart hh_.c < xpart ww_.c):
    pp_ = hh_.e+right*.1nodesize; qq_ = ww_.w+left*.1nodesize;
  else:
    pp_ = ww_.e+right*.1nodesize; qq_ = hh_.w+left*.1nodesize;
  fi
  draw (pp_--qq_) shifted (0, .05nodesize) _rem_;
  draw (pp_--qq_) shifted (0,-.05nodesize) _rem_;
enddef;

vardef linkpairtochildren(suffix hh_, ww_)(text $$) text _rem_ =
  fixmemberpos(hh_,ww_,$$);
  save pp_; pair pp_.c, pp_.s;
  pp_.c = .5[hh_.c,ww_.c];
  pp_.s = .5[hh_.s,ww_.s];
  draw (pp_.c + down*.1nodesize -- pp_.s) _rem_;
  linktochildren(pp_,$$) _rem_;
enddef;
def linkpairtochild = linkpairtochildren enddef;

vardef linksiblings(suffix aa_)(text $$) text _rem_ =
  fixmemberpos(aa_,$$);
  save pp_; pair pp_.c, pp_.s;
  pp_.c = aa_.c + up*2nodesize;
  pp_.s = aa_.c + up*nodesize;
  linktochildren(pp_,aa_,$$) _rem_;
enddef;

def kinshipmarkoptions(text tt_) =
  def _kin_m_op_ = tt_ enddef
enddef;
kinshipmarkoptions(withpen pencircle scaled 2 withcolor .625white);

def markdeceased(text $$) text _rem_ =
  fixmemberpos($$);
  forsuffixes $ = $$:
    draw (dir-45--dir135) scaled
      if xpart ($ne - $nw) = xpart ($e - $w): .9nodesize
      else: .7nodesize fi shifted $cg _kin_m_op_ _rem_;
  endfor
enddef;

def markdivorced(suffix hh_,ww_) =
  fixmemberpos(hh_,ww_);
  draw (dir45--dir-135) scaled .25nodesize shifted .5[hh_.c,ww_.c] _kin_m_op_
enddef;

def kinshipadoptedoptions(text tt_) =
  def _kin_a_op_ = tt_ enddef
enddef;
kinshipadoptedoptions(dashed evenly);

def linktoadoptedchildren(text $$) =
  linktochildren($$) _kin_a_op_
enddef;
let linktoadoptedchild = linktoadoptedchildren;

vardef linkcohabitation(suffix hh_, ww_) text _rem_ =
  fixmemberpos(hh_,ww_);
  save pp_, qq_; pair pp_, qq_;
  if (xpart hh_.c < xpart ww_.c):
    pp_ = hh_.e+right*.1nodesize; qq_ = ww_.w+left*.1nodesize;
  else:
    pp_ = ww_.e+right*.1nodesize; qq_ = hh_.w+left*.1nodesize;
  fi
  draw (pp_{dir45}..{dir45}qq_) shifted (0, .05nodesize) _rem_;
  draw (pp_{dir45}..{dir45}qq_) shifted (0,-.05nodesize) _rem_;
enddef;

def linktemporaryrelation(suffix hh_, ww_) =
  fixmemberpos(hh_,ww_);
  draw (
  if (xpart hh_.c < xpart ww_.c):
    hh_.e+right*.1nodesize{dir45} .. {dir45}ww_.w+left*.1nodesize
  else:
    ww_.e+right*.1nodesize{dir45} .. {dir45}hh_.w+left*.1nodesize
  fi
  )
enddef;

def linkpairtoadoptedchildren(text $$) =
  linkpairtochildren($$) _kin_a_op_
enddef;
let linkpairtoadoptedchild = linkpairtoadoptedchildren;

vardef altmarkdeceased(text $$) text _rem_ =
  fixmemberpos($$);
  save pp_; path pp_;
  forsuffixes $ = $$:
    pp_ := (dir45--dir-135) scaled
      if xpart ($ne - $nw) = xpart ($e - $w): .9nodesize
      else: .7nodesize fi;
    draw pp_ shifted $cg _kin_m_op_ _rem_;
    draw pp_ rotated 90 shifted $cg _kin_m_op_ _rem_;
  endfor
enddef;

vardef linkmarriagebelow(suffix hh_, ww_) text _rem_ = % order: many-one
  fixmemberpos(hh_,ww_);
  save pp_, qq_; pair pp_, qq_;
  if (xpart hh_.c < xpart ww_.c):
    pp_ := hh_.s + right*.2nodesize;
  else:
    pp_ := hh_.s + left *.2nodesize;
  fi
  qq_ := (xpart pp_, min(ypart hh_.s, ypart ww_.s) - 1/3nodesize);
  draw (pp_ -- qq_ -- (xpart ww_.s, ypart qq_) -- ww_.s) _rem_;
enddef;

vardef linkpairtochildrenbelow(suffix hh_, ww_)(text $$) text _rem_ =
  fixmemberpos(hh_,ww_,$$);
  save pp_; pair pp_.c, pp_.s;
  pp_.c = (xpart .5[hh_.c, ww_.c], min(ypart hh_.c, ypart ww_.c) - 1/6nodesize);
  pp_.s = (xpart .5[hh_.s, ww_.s], min(ypart hh_.s, ypart ww_.s) - 1/3nodesize);
  linktochildren(pp_,$$) _rem_;
enddef;
def linkpairtochildbelow = linkpairtochildrenbelow enddef;

def linkpairtoadoptedchildrenbelow(text $$) =
  linkpairtochildrenbelow($$) _kin_a_op_
enddef;
let linkpairtoadoptedchildbelow = linkpairtoadoptedchildrenbelow;

vardef markdivorcedbelow(suffix hh_,ww_) text _rem_ = % order: many-one
  fixmemberpos(hh_,ww_);
  save pp_, qq_; pair pp_.c, qq_.c;
  if (xpart hh_.c < xpart ww_.c):
    pp_.c := hh_.s + right*.2nodesize;
  else:
    pp_.c := hh_.s + left *.2nodesize;
  fi
  pp_.c := (xpart pp_.c,  min(ypart hh_.s, ypart ww_.s) - 1/3nodesize);
  qq_.c := (xpart ww_.s, ypart pp_.c);
  markdivorced(pp_,qq_) _rem_;
enddef;

def linkmarriageandchildren(suffix hh_, ww_)(text $$) text _rem_ =
  linkmarriage(hh_, ww_) _rem_;
  linkpairtochildren(hh_, ww_, $$) _rem_;
enddef;
let linkmarriageandchild = linkmarriageandchildren;

def linkmarriageandchildrenbelow(suffix hh_, ww_)(text $$) text _rem_ =
  linkmarriagebelow(hh_, ww_) _rem_;
  linkpairtochildrenbelow(hh_, ww_, $$) _rem_;
enddef;
let linkmarriageandchildbelow = linkmarriageandchildrenbelow;

vardef labelmembers@#(text $$) text _rem_ =
  fixmemberpos($$);
  forsuffixes $ = $$:
    label@#(str$,
      if     str @# = "bot" : $s
      elseif str @# = "rt"  : $e
      elseif str @# = "top" : $n
      elseif str @# = "lft" : $w
      elseif str @# = "lrt" : $se
      elseif str @# = "urt" : $ne
      elseif str @# = "ulft": $nw
      elseif str @# = "llft": $sw
      else: $cg
      fi
    ) _rem_;
  endfor
enddef;
def labelmember = labelmembers enddef;

vardef lefttoright (suffix aa_)(text $$) =
  save pp_; pair pp_; pp_ := aa_.c;
  forsuffixes $ = $$:
    pp_+right*2nodesize = $c;
    pp_ := $c;
  endfor
enddef;

vardef toptobottom (suffix aa_)(text $$) =
  save pp_; pair pp_; pp_ := aa_.c;
  forsuffixes $ = $$:
    pp_+down*2nodesize = $c;
    pp_ := $c;
  endfor
enddef;

vardef toppairtobottom (suffix aa_,bb_)(text $$) =
  save pp_; pair pp_; pp_ := .5[aa_.c,bb_.c];
  forsuffixes $ = $$:
    pp_+down*2nodesize = $c;
    pp_ := $c;
  endfor
enddef;

vardef bottompairtotop (suffix aa_,bb_)(text $$) =
  save pp_; pair pp_; pp_ := .5[aa_.c,bb_.c];
  forsuffixes $ = $$:
    pp_+up*2nodesize = $c;
    pp_ := $c;
  endfor
enddef;

endinput
