DiagrammeR::grViz("digraph {

graph [layout = dot, rankdir = LR]

# define the global styles of the nodes. We can override these in box if we wish
node [shape = rectangle, style = filled, fillcolor = Linen]

# define datasets here
data [label = ' ', shape = folder, fillcolor = Beige]

# define process steps here
data [label = 'MS_NFI']
process [label = 'Preprocess']
process2 [label = 'Resample']
process3 [label = 'Classify']
process4 [label = 'Convert']
process5 [label = 'MapCodes']
process6 [label = 'Averages']
results [label= 'Initial Community Map']

# edge definitions with the node IDs. Insert datasets inside {...}
{data} -> process -> process2 -> {process3 process4}
process3 -> process5 
process4 -> process6
{process5 process6} -> results
}")