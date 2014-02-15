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

def drawmembers(text tt) =
  forsuffixes member = tt: scantokens _fm_.member; endfor
enddef;

def linktochildren(suffix pp)(text tt) text remn =
  begingroup
    save ymid; numeric ymid;
    ymid := ypart pp.c - nodesize;
    draw (pp.s -- (xpart pp.s, ymid)) remn;
    forsuffixes ch = tt:
      draw ((xpart pp.s, ymid)--(xpart ch.n, ymid)--ch.n) remn;
    endfor
  endgroup
enddef;
let linktochild = linktochildren;

def linkmarriage(suffix hh, ww) text remn =
  begingroup
    save p, q; pair p, q;
    if (xpart hh.c < xpart ww.c):
      p = hh.e+right*.1nodesize; q = ww.w+left*.1nodesize;
    else:
      p = ww.e+right*.1nodesize; q = hh.w+left*.1nodesize;
    fi
    draw (p--q) shifted (0, .05nodesize) remn;
    draw (p--q) shifted (0,-.05nodesize) remn;
  endgroup
enddef;

def linkpairtochildren(suffix hh, ww)(text tt) text remn =
  begingroup
    save pp; pair pp.c, pp.s;
    pp.c = .5[hh.c,ww.c];
    pp.s = .5[hh.s,ww.s];
    draw (pp.c + down*.1nodesize -- pp.s) remn;
    linktochildren(pp,tt) remn;
  endgroup
enddef;
let linkpairtochild = linkpairtochildren;

def linksiblings(suffix aa)(text tt) text remn =
  begingroup
    save pp; pair pp.c, pp.s;
    pp.c = aa.c + up*2nodesize;
    pp.s = aa.c + up*nodesize;
    linktochildren(pp,aa,tt) remn;
  endgroup
enddef;

def markdeceased(text tt) text remn =
  drawoptions(withpen pencircle scaled 2 withcolor .625white);
  forsuffixes m = tt:
    draw (dir-45--dir135) scaled
      if xpart (m.ne - m.nw) = xpart (m.e - m.w): .9nodesize
      else: .7nodesize fi shifted m.cg remn;
  endfor
  drawoptions();
enddef;

def markdivorced(suffix hh,ww) =
  draw (dir45--dir-135) scaled .25nodesize shifted .5[hh.c,ww.c]
    withpen pencircle scaled 2 withcolor .625white
enddef;

def linktoadoptedchildren(text tt) text remn =
  drawoptions(dashed evenly);
  linktochildren(tt) remn;
  drawoptions();
enddef;
let linktoadoptedchild = linktoadoptedchildren;

def linkcohabitation(suffix hh, ww) text remn =
  begingroup
    save p, q; pair p, q;
    if (xpart hh.c < xpart ww.c):
      p = hh.e+right*.1nodesize; q = ww.w+left*.1nodesize;
    else:
      p = ww.e+right*.1nodesize; q = hh.w+left*.1nodesize;
    fi
    draw (p{dir45}..{dir45}q) shifted (0, .05nodesize) remn;
    draw (p{dir45}..{dir45}q) shifted (0,-.05nodesize) remn;
  endgroup
enddef;

def linktemporaryrelation(suffix hh, ww) =
  draw (
  if (xpart hh.c < xpart ww.c):
    hh.e+right*.1nodesize{dir45} .. {dir45}ww.w+left*.1nodesize
  else:
    ww.e+right*.1nodesize{dir45} .. {dir45}hh.w+left*.1nodesize
  fi
  )
enddef;

def linkpairtoadoptedchildren(text tt) text remn =
  drawoptions(dashed evenly);
  linkpairtochildren(tt) remn;
  drawoptions();
enddef;
let linkpairtoadoptedchild = linkpairtoadoptedchildren;

def altmarkdeceased(text tt) text remn =
  begingroup
    drawoptions(withpen pencircle scaled 2 withcolor .625white);
    save p; path p;
    forsuffixes m = tt:
      p := (dir45--dir-135) scaled
        if xpart (m.ne - m.nw) = xpart (m.e - m.w): .9nodesize
        else: .7nodesize fi;
      draw p shifted m.cg remn;
      draw p rotated 90 shifted m.cg remn;
    endfor
    drawoptions();
  endgroup
enddef;

def linkmarriagebelow(suffix hh, ww) text remn = % order is important: many-one
  begingroup
    save p, q; pair p, q;
    if (xpart hh.c < xpart ww.c):
      p := hh.s + right*.2nodesize;
    else:
      p := hh.s + left *.2nodesize;
    fi
    q := (xpart p, min(ypart hh.s, ypart ww.s) - .333nodesize);
    draw (p -- q -- (xpart ww.s, ypart q) -- ww.s) remn;
  endgroup
enddef;

def linkpairtochildrenbelow(suffix hh, ww)(text tt) text remn =
  begingroup
    save pp; pair pp.c, pp.s;
    pp.c = (xpart .5[hh.c, ww.c], min(ypart hh.c, ypart ww.c) - .167nodesize);
    pp.s = (xpart .5[hh.s, ww.s], min(ypart hh.s, ypart ww.s) - .333nodesize);
    linktochildren(pp,tt) remn;
  endgroup
enddef;
let linkpairtochildbelow = linkpairtochildrenbelow;

def linkpairtoadoptedchildrenbelow(text tt) text remn =
  drawoptions(dashed evenly);
  linkpairtochildrenbelow(tt) remn;
  drawoptions();
enddef;
let linkpairtoadoptedchildbelow = linkpairtoadoptedchildrenbelow;

def markdivorcedbelow(suffix hh,ww) text remn = % order is important: many-one
  begingroup
    save p, q; pair p.c, q.c;
    if (xpart hh.c < xpart ww.c):
      p.c := hh.s + right*.2nodesize;
    else:
      p.c := hh.s + left *.2nodesize; 
    fi
    p.c := (xpart p.c,  min(ypart hh.s, ypart ww.s) - .333nodesize);
    q.c := (xpart ww.s, ypart p.c);
    markdivorced(p,q) remn;
  endgroup
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

endinput
