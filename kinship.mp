% kinship diagram for anthropology

numeric membersize; membersize := 1cm;

vardef male@#(text col) =
  pair @#.c, @#.n, @#.s, @#.w, @#.e, @#.sw, @#.se, @#.nw, @#.ne, @#.cg;
  @#.cg = @#.c + (0,-.167membersize); % center of gravity
  @#.n  = dir90 *.667membersize + @#.cg;
  @#.sw = dir210*.667membersize + @#.cg;
  @#.se = dir330*.667membersize + @#.cg;
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
  @#.n  = dir90 *.5membersize + @#.c;
  @#.w  = dir180*.5membersize + @#.c;
  @#.s  = dir270*.5membersize + @#.c;
  @#.e  = dir0  *.5membersize + @#.c;
  @#.ne = dir45 *.5membersize + @#.c;
  @#.nw = dir135*.5membersize + @#.c;
  @#.se = dir315*.5membersize + @#.c;
  @#.sw = dir225*.5membersize + @#.c;
  @#.cg = @#.c;
  string _fm_.@#; _fm_.@# :=
    "fill fullcircle scaled "&decimal membersize &" shifted "&str @#
    &".c withcolor "&str col &";draw fullcircle scaled "&decimal membersize
    &" shifted "&str @# &".c;";
enddef;

vardef unidentified@#(text col) =
  pair @#.c, @#.n, @#.s, @#.w, @#.e, @#.sw, @#.se, @#.nw, @#.ne, @#.cg;
  @#.ne = @#.c + (.5membersize, .5membersize);
  @#.sw = @#.c - (.5membersize, .5membersize);
  @#.se = @#.c + (.5membersize,-.5membersize);
  @#.nw = @#.c - (.5membersize,-.5membersize);
  @#.n  = .5[@#.nw, @#.ne];
  @#.s  = .5[@#.sw, @#.se];
  @#.e  = .5[@#.ne, @#.se];
  @#.w  = .5[@#.nw, @#.sw];
  @#.cg = @#.c;
  string _fm_.@#; _fm_.@# :=
    "fill unitsquare scaled "&decimal membersize &" shifted "&str @#
    &".sw withcolor "&str col &";draw unitsquare scaled "&decimal membersize
    &" shifted "&str @# &".sw;";
enddef;

def drawmembers(text tt) =
  forsuffixes member = tt: scantokens _fm_.member; endfor
enddef;

def linktochildren(suffix pp)(text tt) =
  begingroup
    save count, ymid; numeric count, ymid; count := 0;
    forsuffixes ch = tt:
      if count = 0: ymid := ypart .5[pp.c, ch.c]; fi
      draw if count = 0: pp.s-- fi
        (xpart pp.s, ymid)--(xpart ch.n, ymid)--ch.n;
      count := count + 1;
    endfor
  endgroup
enddef;
let linktochild = linktochildren;

def linkmarriage(suffix hh, ww) =
  if (xpart hh.c < xpart ww.c):
    draw hh.e+(.1membersize, .05membersize) -- ww.w+(-.1membersize, .05membersize);
    draw hh.e+(.1membersize,-.05membersize) -- ww.w+(-.1membersize,-.05membersize);
  else:
    draw ww.e+(.1membersize, .05membersize) -- hh.w+(-.1membersize, .05membersize);
    draw ww.e+(.1membersize,-.05membersize) -- hh.w+(-.1membersize,-.05membersize);
  fi
enddef;

def linkpairtochildren(suffix hh, ww)(text tt) =
  begingroup
    save pp; pair pp.c, pp.s;
    pp.c = .5[hh.c,ww.c];
    pp.s = .5[hh.s,ww.s];
    draw pp.c + down*.1membersize -- pp.s;
    linktochildren(pp,tt);
  endgroup
enddef;
let linkpairtochild = linkpairtochildren;

def linksiblings(suffix aa)(text tt) =
  begingroup
    save pp; pair pp.c, pp.s;
    pp.c = aa.c + up*2membersize;
    pp.s = aa.c + up*membersize;
    linktochildren(pp,aa,tt);
  endgroup
enddef;

def markdeceased(text tt) =
  forsuffixes m = tt:
    draw (dir-45--dir135) scaled
      if xpart (m.ne - m.nw) = xpart (m.e - m.w): .9membersize
      else: .7membersize fi shifted m.cg
      withpen pencircle scaled 2 withcolor .625white;
  endfor
enddef;

def markdivorced(suffix hh,ww) =
  draw (dir45--dir-135) scaled .25membersize shifted .5[hh.c,ww.c]
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
    draw hh.e+(.1membersize, .05membersize){dir45} .. {dir45}ww.w+(-.1membersize, .05membersize);
    draw hh.e+(.1membersize,-.05membersize){dir45} .. {dir45}ww.w+(-.1membersize,-.05membersize);
  else:
    draw ww.e+(.1membersize, .05membersize){dir45} .. {dir45}hh.w+(-.1membersize, .05membersize);
    draw ww.e+(.1membersize,-.05membersize){dir45} .. {dir45}hh.w+(-.1membersize,-.05membersize);
  fi
enddef;

def linktemporaryrelation(suffix hh, ww) =
  if (xpart hh.c < xpart ww.c):
    draw hh.e+(.1membersize, 0){dir45} .. {dir45}ww.w+(-.1membersize, 0);
  else:
    draw ww.e+(.1membersize, 0){dir45} .. {dir45}hh.w+(-.1membersize, 0);
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
        if xpart (m.ne - m.nw) = xpart (m.e - m.w): .9membersize
        else: .7membersize fi;
      draw p shifted m.cg withpen pencircle scaled 2 withcolor .625white;
      draw p rotated 90 shifted m.cg withpen pencircle scaled 2 withcolor .625white;
    endfor
  endgroup
enddef;

def linkmarriageunder(suffix hh,ww) = % the order is important: many-one
  begingroup
    save p, q; pair p, q;
    if (xpart hh.c < xpart ww.c):
      p := hh.s + right*.2membersize;
    else:
      p := hh.s + left *.2membersize; 
    fi
    q := p + down*abs(ypart p - ypart ww.s) + down*.333membersize;
    draw p -- q -- (xpart ww.s, ypart q) -- ww.s;
  endgroup
enddef;

def linkpairtochildrenunder(suffix hh,ww)(text tt) =
  begingroup
    save pp; pair pp.c, pp.s;
    pp.c = (xpart .5[hh.c,ww.c], min(ypart hh.c, ypart ww.c));
    pp.s = (xpart .5[hh.s,ww.s], min(ypart hh.s, ypart ww.s));
    pp.c := pp.c + down*.333membersize;
    if (xpart hh.c < xpart ww.c):
      pp.s := pp.s + right*.1membersize + down*.333membersize;
    else:
      pp.s := pp.s + left *.1membersize + down*.333membersize; 
    fi
    linktochildren(pp,tt);
  endgroup
enddef;
let linkpairtochildunder = linkpairtochildrenunder;

def linkpairtoadoptedchildrenunder(text tt) =
  drawoptions(dashed evenly);
  linkpairtochildrenunder(tt);
  drawoptions();
enddef;
let linkpairtoadoptedchildunder = linkpairtoadoptedchildrenunder;

def markdivorcedunder(suffix hh,ww) = % the order is important: many-one
  begingroup
    save p, q; pair p.c, q.c;
    if (xpart hh.c < xpart ww.c):
      p.c := hh.s + right*.2membersize;
    else:
      p.c := hh.s + left *.2membersize; 
    fi
    p.c := p.c + down*abs(ypart p.c - ypart ww.s) + down*.333membersize;
    q.c := (xpart ww.s, ypart p.c);
    markdivorced(p,q);
  endgroup
enddef;

endinput

% usage:
%  u := membersize;
%  male.ego(black); ego.c = origin; label.bot(btex ego etex, ego.s);
%  female.mom(black); mom.c = (1u,2u);
%  female.sister(black); sister.c = (2u,0);
%  female.niece(black); niece.c = (1u,-2u);
%  male.nephew(black); nephew.c = niece.c shifted (2u,0);
%  female.wife(white); wife.c = (-2u,0);
%  male.son(white); son.c = (-1u,-2u);
%  male.grndson(black); grndson.c = (0,-4u);
%  linktochildren(mom, ego, sister);
%  linktochildren(sister, niece, nephew);
%  linkmarriage(ego, wife);
%  linkmarriage(son, niece);
%  linkpairtochild(ego, wife, son);
%  linkpairtochild(son, niece, grndson);
%  drawmembers(ego,mom,sister,niece,nephew,wife,son,grndson);
