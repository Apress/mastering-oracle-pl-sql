create table mydocs(
    id           number primary key,
    name         varchar2(256) not null,
    mime_type    varchar2(128),
    doc_size     number,
    dad_charset  varchar2(128),
    last_updated date,
    content_type varchar2(128),
    blob_content blob
)
/

create sequence mydocs_seq
/

create or replace trigger biu_mydocs
    before insert or update on mydocs
    for each row
begin
    if :new.id is null then
        select mydocs_seq.nextval into :new.id from dual;
    end if;
end;
/
