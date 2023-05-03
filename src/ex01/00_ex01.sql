
with recursive sub_graph as 
    (select point1,
         point2,
         cost,
         1 as points_quantity,
         array [point1] as path,
         false as loop,
         array [cost] as costs
    from nodes
    where point1 = 'a'
    union
    select nodes.point1,
         nodes.point2,
         nodes.cost + sub_graph.cost as cost,
         sub_graph.points_quantity + 1 as points_quantity,
         sub_graph.path || nodes.point1 as path,
         nodes.point1 = any (sub_graph.path) as loop,
         sub_graph.costs || nodes.cost as costs
    from nodes
    join sub_graph
        on sub_graph.point2 = nodes.point1
            and not loop),
results as (select cost - costs[5] as total_cost,
        path as tour
    from sub_graph
    where points_quantity = 5
        and 'a' = any (path)
        and 'b' = any (path)
        and 'c' = any (path)
        and 'd' = any (path)
        and path[1] = 'a'
        and path[5] = 'a')

select distinct *
from results 
where total_cost = 
    (select min(total_cost) from results)
    or total_cost = (select max(total_cost) from results)
order by  total_cost, tour; 
