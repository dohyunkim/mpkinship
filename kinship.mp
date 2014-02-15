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

def linktochildren(suffix pp)(text tt) =
  begingroup
    save ymid; numeric ymid;
    ymid := ypart pp.c - nodesize;
    draw pp.s -- (xpart pp.s, ymid);
    forsuffixes ch = tt:
      draw (xpart pp.s, ymid)--(xpart ch.n, ymid)--ch.n;
    endfor
  endgroup
enddef;
let linktochild = linktochildren;

def linkmarriage(suffix hh, ww) =
  if (xpart hh.c < xpart ww.c):
    draw hh.e+(.1nodesize, .05nodesize) -- ww.w+(-.1nodesize, .05nodesize);
    draw hh.e+(.1nodesize,-.05nodesize) -- ww.w+(-.1nodesize,-.05nodesize);
  else:
    draw ww.e+(.1nodesize, .05nodesize) -- hh.w+(-.1nodesize, .05nodesize);
    draw ww.e+(.1nodesize,-.05nodesize) -- hh.w+(-.1nodesize,-.05nodesize);
  fi
enddef;

def linkpairtochildren(suffix hh, ww)(text tt) =
  begingroup
    save pp; pair pp.c, pp.s;
    pp.c = .5[hh.c,ww.c];
    pp.s = .5[hh.s,ww.s];
    draw pp.c + down*.1nodesize -- pp.s;
    linktochildren(pp,tt);
  endgroup
enddef;
let linkpairtochild = linkpairtochildren;

def linksiblings(suffix aa)(text tt) =
  begingroup
    save pp; pair pp.c, pp.s;
    pp.c = aa.c + up*2nodesize;
    pp.s = aa.c + up*nodesize;
    linktochildren(pp,aa,tt);
  endgroup
enddef;

def markdeceased(text tt) =
  forsuffixes m = tt:
    draw (dir-45--dir135) scaled
      if xpart (m.ne - m.nw) = xpart (m.e - m.w): .9nodesize
      else: .7nodesize fi shifted m.cg
      withpen pencircle scaled 2 withcolor .625white;
  endfor
enddef;

def markdivorced(suffix hh,ww) =
  draw (dir45--dir-135) scaled .25nodesize shifted .5[hh.c,ww.c]
    withpen pencircle scaled 2 withcolor .625white;
enddef;

def linktoadoptedchildren(text tt) =
  drawoptions(dashed evenly);
  linktochildren(tt);
  drawoptions();
enddef;
let linktoadoptedchild = linktoadoptedchildren;

def linkcohabitation(suffix hh, ww) =
  if (xpart hh.c < xpart ww.c):
    draw hh.e+(.1nodesize, .05nodesize){dir45} .. {dir45}ww.w+(-.1nodesize, .05nodesize);
    draw hh.e+(.1nodesize,-.05nodesize){dir45} .. {dir45}ww.w+(-.1nodesize,-.05nodesize);
  else:
    draw ww.e+(.1nodesize, .05nodesize){dir45} .. {dir45}hh.w+(-.1nodesize, .05nodesize);
    draw ww.e+(.1nodesize,-.05nodesize){dir45} .. {dir45}hh.w+(-.1nodesize,-.05nodesize);
  fi
enddef;

def linktemporaryrelation(suffix hh, ww) =
  if (xpart hh.c < xpart ww.c):
    draw hh.e+(.1nodesize, 0){dir45} .. {dir45}ww.w+(-.1nodesize, 0);
  else:
    draw ww.e+(.1nodesize, 0){dir45} .. {dir45}hh.w+(-.1nodesize, 0);
  fi
enddef;

def linkpairtoadoptedchildren(text tt) =
  drawoptions(dashed evenly);
  linkpairtochildren(tt);
  drawoptions();
enddef;
let linkpairtoadoptedchild = linkpairtoadoptedchildren;

def altmarkdeceased(text tt) =
  begingroup
    save p; path p;
    forsuffixes m = tt:
      p := (dir45--dir-135) scaled
        if xpart (m.ne - m.nw) = xpart (m.e - m.w): .9nodesize
        else: .7nodesize fi;
      draw p shifted m.cg withpen pencircle scaled 2 withcolor .625white;
      draw p rotated 90 shifted m.cg withpen pencircle scaled 2 withcolor .625white;
    endfor
  endgroup
enddef;

def linkmarriagebelow(suffix hh, ww) = % the order is important: many-one
  begingroup
    save p, q; pair p, q;
    if (xpart hh.c < xpart ww.c):
      p := hh.s + right*.2nodesize;
    else:
      p := hh.s + left *.2nodesize;
    fi
    q := (xpart p, min(ypart hh.s, ypart ww.s) - .333nodesize);
    draw p -- q -- (xpart ww.s, ypart q) -- ww.s;
  endgroup
enddef;

def linkpairtochildrenbelow(suffix hh, ww)(text tt) =
  begingroup
    save pp; pair pp.c, pp.s;
    pp.c = (xpart .5[hh.c, ww.c], min(ypart hh.c, ypart ww.c) - .167nodesize);
    pp.s = (xpart .5[hh.s, ww.s], min(ypart hh.s, ypart ww.s) - .333nodesize);
    linktochildren(pp,tt);
  endgroup
enddef;
let linkpairtochildbelow = linkpairtochildrenbelow;

def linkpairtoadoptedchildrenbelow(text tt) =
  drawoptions(dashed evenly);
  linkpairtochildrenbelow(tt);
  drawoptions();
enddef;
let linkpairtoadoptedchildbelow = linkpairtoadoptedchildrenbelow;

def markdivorcedbelow(suffix hh,ww) = % the order is important: many-one
  begingroup
    save p, q; pair p.c, q.c;
    if (xpart hh.c < xpart ww.c):
      p.c := hh.s + right*.2nodesize;
    else:
      p.c := hh.s + left *.2nodesize; 
    fi
    p.c := (xpart p.c,  min(ypart hh.s, ypart ww.s) - .333nodesize);
    q.c := (xpart ww.s, ypart p.c);
    markdivorced(p,q);
  endgroup
enddef;

def linkmarriageandchildren(suffix hh, ww)(text tt) =
  linkmarriage(hh, ww);
  linkpairtochildren(hh, ww, tt);
enddef;
let linkmarriageandchild = linkmarriageandchildren;

def linkmarriageandchildrenbelow(suffix hh, ww)(text tt) =
  linkmarriagebelow(hh, ww);
  linkpairtochildrenbelow(hh, ww, tt);
enddef;
let linkmarriageandchildbelow = linkmarriageandchildrenbelow;

endinput
