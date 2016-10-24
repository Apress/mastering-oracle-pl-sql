create table scout
    (id number,
     rank varchar2(30) not null
    constraint check_rank 
    check (rank in 
    ('Scout','Tenderfoot','Star Scout','Life Scout','Eagle Scout'))
);


create or replace trigger tbur_scout before update on scout
    for each row
    when (new.rank <> old.rank)
    declare
    type ranklist is varray(10) of varchar2(30);
 ranks ranklist := ranklist('Scout','Tenderfoot','Star Scout',
 'Life Scout','Eagle Scout');
    function diff (p_new in varchar2,p_old in varchar2)
    return number is
   newRank number;
   oldRank number;
   begin
   for i in 1..ranks.last loop
      if p_new = ranks(i) then
        newRank := i;
      elsif
        p_old = ranks(i) then
        oldRank := i;
      end if;
   end loop;
   return newRank - oldRank;
   end; 
   
   begin
   
   if  diff(:new.rank,:old.rank) != 1 then
         raise_application_error(-20001,'Rank is out of sequence');
   end if;
   
   end;
/

