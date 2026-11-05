import matplotlib; matplotlib.use("Agg")
import matplotlib.pyplot as plt, math
from matplotlib.patches import Ellipse, Rectangle, Polygon, Circle
plt.rcParams['font.family']='Liberation Sans'
LINE='#9a9a9a'; INK='#111111'
class ERD:
    def __init__(s,W,H,fig_w,fs=14):
        s.W,s.H,s.fs=W,H,fs
        s.fig=plt.figure(figsize=(fig_w,fig_w*H/W)); s.ax=s.fig.add_axes([0,0,1,1])
        s.ax.set_xlim(0,W); s.ax.set_ylim(0,H); s.ax.axis('off'); s.ax.set_aspect('equal')
        s.u=fig_w/W*72   # points per unit
        s.shapes={}
    def tw(s,t,k=0.56): return len(t)*s.fs*k/s.u   # text width in units
    def line(s,p,q,c=LINE,lw=1.1,z=1): s.ax.plot([p[0],q[0]],[p[1],q[1]],color=c,lw=lw,zorder=z,solid_capstyle='round')
    def entity(s,name,x,y,minw=12):
        w=max(s.tw(name,0.62)+4,minw); h=5.2
        s.ax.add_patch(Rectangle((x-w/2,y-h/2),w,h,fc='white',ec=INK,lw=1.4,zorder=3,joinstyle='round'))
        s.ax.text(x,y,name,ha='center',va='center',fontsize=s.fs,zorder=4)
        s.shapes[name]=('e',x,y,w,h)
    def attr(s,name,x,y,owner,key=False):
        w=max(s.tw(name)+5,11); h=6.2
        ox,oy=s.shapes[owner][1:3]; ow,oh=s.shapes[owner][3:5]
        # garis ke tepi entitas
        dx,dy=x-ox,y-oy
        t=min((ow/2)/abs(dx) if dx else 1e9,(oh/2)/abs(dy) if dy else 1e9)
        s.line((ox+dx*t,oy+dy*t),(x,y))
        s.ax.add_patch(Ellipse((x,y),w,h,fc='white',ec=INK,lw=1.2,zorder=3))
        s.ax.text(x,y,name,ha='center',va='center',fontsize=s.fs-1,zorder=4)
        if key: 
            tw=s.tw(name); s.line((x-tw/2,y-1.25),(x+tw/2,y-1.25),c=INK,lw=1.0,z=5)
    def rel(s,name,x,y):
        w=max(s.tw(name)+7,16); h=8.2
        s.ax.add_patch(Polygon([(x-w/2,y),(x,y+h/2),(x+w/2,y),(x,y-h/2)],fc='white',ec=INK,lw=1.2,zorder=3))
        s.ax.text(x,y,name,ha='center',va='center',fontsize=s.fs-1,zorder=4)
        s.shapes['r:'+name]=('r',x,y,w,h)
    def anchor(s,key,toward):
        k,x,y,w,h=s.shapes[key]; tx,ty=toward; dx,dy=tx-x,ty-y
        if k=='r':
            t=1/(abs(dx)/(w/2)+abs(dy)/(h/2)) if (dx or dy) else 0
        else:
            t=min((w/2)/abs(dx) if dx else 1e9,(h/2)/abs(dy) if dy else 1e9)
        return (x+dx*t,y+dy*t)
    def link(s,ent,rel,sym,side=None):
        r=s.shapes['r:'+rel]; e=s.shapes[ent]
        q=s.anchor(ent,(r[1],r[2])) if side is None else side
        p=s.anchor('r:'+rel,(e[1],e[2]))
        s.line(p,q,c=INK,lw=1.2,z=2); s.sym(q,p,sym)
    def sym(s,q,p,sym):
        dx,dy=p[0]-q[0],p[1]-q[1]; d=math.hypot(dx,dy); ux,uy=dx/d,dy/d; nx,ny=-uy,ux
        P=lambda a,b:(q[0]+ux*a+nx*b,q[1]+uy*a+ny*b)
        def bar(a): s.line(P(a,-1.5),P(a,1.5),c=INK,lw=1.6,z=5)
        def foot():
            for b in (-1.7,0,1.7): s.line(P(2.4,0),P(0,b),c=INK,lw=1.4,z=5)
        def circ(a): s.ax.add_patch(Circle(P(a,0),0.95,fc='white',ec=INK,lw=1.3,zorder=6))
        if sym=='one': bar(1.2); bar(2.2)
        elif sym=='many0': foot(); circ(3.5)
        elif sym=='many1': foot(); bar(3.2)
        elif sym=='one0': bar(1.2); circ(3.0)
    def save(s,path,dpi=200): s.fig.savefig(path,dpi=dpi,facecolor='white'); plt.close(s.fig)
