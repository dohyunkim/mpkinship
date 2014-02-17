% kinship diagram for anthropology

numeric nodesize; nodesize := 1cm;

vardef male@#(text col) =
  pair @#.c, @#.n, @#.s, @#.w, @#.e, @#.sw, @#.se, @#.nw, @#.ne, @#.cg;
  @#.cg = @#.c + (0,-.167nodesize); % center of gravity
  @#.n  = dir90 *.667nodesize + @#.cg;
  @#.sw = dir210*.667nodesize + @#.cg;
  @#.se = dir330*.667nodesize + @#.cg;
  @#.nw = @#.n; @#.ne = @#.n;
  @#.s  = 1/2[@#.se,@#.sw];
  @#.w  = 1/2[@#.n, @#.sw];
  @#.e  = 1/2[@#.n, @#.se];
  string _fm_.@#; _fm_.@# :=
    "fill "&str @# &".n--"&str @# &".sw--"&str @# &".se--cycle withcolor "
    &str col &";draw "&str @# &".n--"&str @# &".sw--"&str @# &".se--cycle;";
enddef;

vardef female@#(text col) =
  pair @#.c, @#.n, @#.s, @#.w, @#.e, @#.sw, @#.se, @#.nw, @#.ne, @#.cg;
  @#.n  = dir90 *.5nodesize + @#.c;
  @#.w  = dir180*.5nodesize + @#.c;
  @#.s  = dir270*.5nodesize + @#.c;
  @#.e  = dir0  *.5nodesize + @#.c;
  @#.ne = dir45 *.5nodesize + @#.c;
  @#.nw = dir135*.5nodesize + @#.c;
  @#.se = dir315*.5nodesize + @#.c;
  @#.sw = dir225*.5nodesize + @#.c;
  @#.cg = @#.c;
  string _fm_.@#; _fm_.@# :=
    "fill fullcircle scaled "&decimal nodesize &" shifted "&str @#
    &".c withcolor "&str col &";draw fullcircle scaled "&decimal nodesize
    &" shifted "&str @# &".c;";
enddef;

vardef unidentified@#(text col) =
  pair @#.c, @#.n, @#.s, @#.w, @#.e, @#.sw, @#.se, @#.nw, @#.ne, @#.cg;
  @#.ne = @#.c + (.5nodesize, .5nodesize);
  @#.sw = @#.c - (.5nodesize, .5nodesize);
  @#.se = @#.c + (.5nodesize,-.5nodesize);
  @#.nw = @#.c - (.5nodesize,-.5nodesize);
  @#.n  = .5[@#.nw, @#.ne];
  @#.s  = .5[@#.sw, @#.se];
  @#.e  = .5[@#.ne, @#.se];
  @#.w  = .5[@#.nw, @#.sw];
  @#.cg = @#.c;
  string _fm_.@#; _fm_.@# :=
    "fill unitsquare scaled "&decimal nodesize &" shifted "&str @#
    &".sw withcolor "&str col &";draw unitsquare scaled "&decimal nodesize
    &" shifted "&str @# &".sw;";
enddef;

def fixmemberpos(text tt) =
  forsuffixes m = tt:
    if unknown m.c: m.c = origin; fi
  endfor
enddef;

def drawmembers(text tt) =
  fixmemberpos(tt);
  forsuffixes member = tt: scantokens _fm_.member; endfor
enddef;

vardef linktochildren(suffix pp)(text tt) text remn =
  fixmemberpos(pp,tt);
  save ymid; numeric ymid;
  ymid := ypart pp.c - nodesize;
  draw (pp.s -- (xpart pp.s, ymid)) remn;
  forsuffixes ch = tt:
    draw ((xpart pp.s, ymid)--(xpart ch.n, ymid)--ch.n) remn;
  endfor
enddef;
def linktochild = linktochildren enddef;

vardef linkmarriage(suffix hh, ww) text remn =
  fixmemberpos(hh,ww);
  save p, q; pair p, q;
  if (xpart hh.c < xpart ww.c):
    p = hh.e+right*.1nodesize; q = ww.w+left*.1nodesize;
  else:
    p = ww.e+right*.1nodesize; q = hh.w+left*.1nodesize;
  fi
  draw (p--q) shifted (0, .05nodesize) remn;
  draw (p--q) shifted (0,-.05nodesize) remn;
enddef;

vardef linkpairtochildren(suffix hh, ww)(text tt) text remn =
  fixmemberpos(hh,ww,tt);
  save pp; pair pp.c, pp.s;
  pp.c = .5[hh.c,ww.c];
  pp.s = .5[hh.s,ww.s];
  draw (pp.c + down*.1nodesize -- pp.s) remn;
  linktochildren(pp,tt) remn;
enddef;
def linkpairtochild = linkpairtochildren enddef;

vardef linksiblings(suffix aa)(text tt) text remn =
  fixmemberpos(aa,tt);
  save pp; pair pp.c, pp.s;
  pp.c = aa.c + up*2nodesize;
  pp.s = aa.c + up*nodesize;
  linktochildren(pp,aa,tt) remn;
enddef;

def kinshipmarkoptions(text t) =
  def _kin_m_op_ = t enddef
enddef;
kinshipmarkoptions(withpen pencircle scaled 2 withcolor .625white);

def markdeceased(text tt) text remn =
  fixmemberpos(tt);
  forsuffixes m = tt:
    draw (dir-45--dir135) scaled
      if xpart (m.ne - m.nw) = xpart (m.e - m.w): .9nodesize
      else: .7nodesize fi shifted m.cg _kin_m_op_ remn;
  endfor
enddef;

def markdivorced(suffix hh,ww) =
  fixmemberpos(hh,ww);
  draw (dir45--dir-135) scaled .25nodesize shifted .5[hh.c,ww.c] _kin_m_op_
enddef;

def kinshipadoptedoptions(text t) =
  def _kin_a_op_ = t enddef
enddef;
kinshipadoptedoptions(dashed evenly);

def linktoadoptedchildren(text tt) =
  linktochildren(tt) _kin_a_op_
enddef;
let linktoadoptedchild = linktoadoptedchildren;

vardef linkcohabitation(suffix hh, ww) text remn =
  fixmemberpos(hh,ww);
  save p, q; pair p, q;
  if (xpart hh.c < xpart ww.c):
    p = hh.e+right*.1nodesize; q = ww.w+left*.1nodesize;
  else:
    p = ww.e+right*.1nodesize; q = hh.w+left*.1nodesize;
  fi
  draw (p{dir45}..{dir45}q) shifted (0, .05nodesize) remn;
  draw (p{dir45}..{dir45}q) shifted (0,-.05nodesize) remn;
enddef;

def linktemporaryrelation(suffix hh, ww) =
  fixmemberpos(hh,ww);
  draw (
  if (xpart hh.c < xpart ww.c):
    hh.e+right*.1nodesize{dir45} .. {dir45}ww.w+left*.1nodesize
  else:
    ww.e+right*.1nodesize{dir45} .. {dir45}hh.w+left*.1nodesize
  fi
  )
enddef;

def linkpairtoadoptedchildren(text tt) =
  linkpairtochildren(tt) _kin_a_op_
enddef;
let linkpairtoadoptedchild = linkpairtoadoptedchildren;

vardef altmarkdeceased(text tt) text remn =
  fixmemberpos(tt);
  save p; path p;
  forsuffixes m = tt:
    p := (dir45--dir-135) scaled
      if xpart (m.ne - m.nw) = xpart (m.e - m.w): .9nodesize
      else: .7nodesize fi;
    draw p shifted m.cg _kin_m_op_ remn;
    draw p rotated 90 shifted m.cg _kin_m_op_ remn;
  endfor
enddef;

vardef linkmarriagebelow(suffix hh, ww) text remn = % order: many-one
  fixmemberpos(hh,ww);
  save p, q; pair p, q;
  if (xpart hh.c < xpart ww.c):
    p := hh.s + right*.2nodesize;
  else:
    p := hh.s + left *.2nodesize;
  fi
  q := (xpart p, min(ypart hh.s, ypart ww.s) - .333nodesize);
  draw (p -- q -- (xpart ww.s, ypart q) -- ww.s) remn;
enddef;

vardef linkpairtochildrenbelow(suffix hh, ww)(text tt) text remn =
  fixmemberpos(hh,ww,tt);
  save pp; pair pp.c, pp.s;
  pp.c = (xpart .5[hh.c, ww.c], min(ypart hh.c, ypart ww.c) - .167nodesize);
  pp.s = (xpart .5[hh.s, ww.s], min(ypart hh.s, ypart ww.s) - .333nodesize);
  linktochildren(pp,tt) remn;
enddef;
def linkpairtochildbelow = linkpairtochildrenbelow enddef;

def linkpairtoadoptedchildrenbelow(text tt) =
  linkpairtochildrenbelow(tt) _kin_a_op_
enddef;
let linkpairtoadoptedchildbelow = linkpairtoadoptedchildrenbelow;

vardef markdivorcedbelow(suffix hh,ww) text remn = % order: many-one
  fixmemberpos(hh,ww);
  save p, q; pair p.c, q.c;
  if (xpart hh.c < xpart ww.c):
    p.c := hh.s + right*.2nodesize;
  else:
    p.c := hh.s + left *.2nodesize;
  fi
  p.c := (xpart p.c,  min(ypart hh.s, ypart ww.s) - .333nodesize);
  q.c := (xpart ww.s, ypart p.c);
  markdivorced(p,q) remn;
enddef;

def linkmarriageandchildren(suffix hh, ww)(text tt) text remn =
  linkmarriage(hh, ww) remn;
  linkpairtochildren(hh, ww, tt) remn;
enddef;
let linkmarriageandchild = linkmarriageandchildren;

def linkmarriageandchildrenbelow(suffix hh, ww)(text tt) text remn =
  linkmarriagebelow(hh, ww) remn;
  linkpairtochildrenbelow(hh, ww, tt) remn;
enddef;
let linkmarriageandchildbelow = linkmarriageandchildrenbelow;

vardef labelmembers@#(text tt) text remn =
  fixmemberpos(tt);
  forsuffixes m = tt:
    label@#(str m,
      if     str @# = "bot" : m.s
      elseif str @# = "rt"  : m.e
      elseif str @# = "top" : m.n
      elseif str @# = "lft" : m.w
      elseif str @# = "lrt" : m.se
      elseif str @# = "urt" : m.ne
      elseif str @# = "ulft": m.nw
      elseif str @# = "llft": m.sw
      else: m.cg
      fi
    ) remn;
  endfor
enddef;
def labelmember = labelmembers enddef;

vardef lefttoright (suffix aa)(text tt) =
  save p; pair p; p := aa.c;
  forsuffixes m = tt:
    p+right*2nodesize = m.c;
    p := m.c;
  endfor
enddef;

vardef toptobottom (suffix aa)(text tt) =
  save p; pair p; p := aa.c;
  forsuffixes m = tt:
    p+down*2nodesize = m.c;
    p := m.c;
  endfor
enddef;

vardef toppairtobottom (suffix aa,bb)(text tt) =
  save p; pair p; p := .5[aa.c,bb.c];
  forsuffixes m = tt:
    p+down*2nodesize = m.c;
    p := m.c;
  endfor
enddef;

vardef bottompairtotop (suffix aa,bb)(text tt) =
  save p; pair p; p := .5[aa.c,bb.c];
  forsuffixes m = tt:
    p+up*2nodesize = m.c;
    p := m.c;
  endfor
enddef;

endinput
