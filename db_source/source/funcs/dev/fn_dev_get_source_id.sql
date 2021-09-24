drop function test.fn_dev_get_source_id;
create or replace function test.fn_dev_get_source_id(source_name text, source_link text, resource text) returns integer
    language plpgsql
as
$$
DECLARE
        id_ integer;
        links_ jsonb;
    BEGIN
        EXECUTE
            'SELECT id, links FROM test.sources WHERE name=$1;'
        INTO id_, links_
        USING source_name, source_link;
        IF id_ isnull THEN
            EXECUTE
                'INSERT INTO test.sources(name, links) VALUES ($1, $2) RETURNING id;'
            INTO id_
            USING source_name, jsonb_build_object(resource, source_link);
        ELSE
            IF links_ @> jsonb_build_object(resource, source_link)::jsonb is false THEN
                UPDATE test.sources
                SET links = links_ || jsonb_build_object(resource, source_link)
                WHERE id=id_;
            end if;
        end if;
        return id_;
    END
$$;
alter function test.fn_dev_get_source_id(text, text, text) owner to bkmanager;
------------------------------------------------------------------------------
------------------------------------------------------------------------------