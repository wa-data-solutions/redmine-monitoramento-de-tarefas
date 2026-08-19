SELECT
    /* ============================================================
       PROJETO / UNIDADE
       ============================================================ */
    i.project_id AS cod_unidade,
    p.name AS unidade,
    t.name AS rastreador_tarefa,

    /* ============================================================
       TAREFA PAI
       ============================================================ */
    i.parent_id AS cod_tarefa,
    st.subject AS tarefa,
    TO_CHAR(st.created_on, 'DD/MM/YYYY') AS data_registro_tarefa,
    stp.name AS situacao_tarefa,

    CASE
        WHEN i.priority_id = 4  THEN 'Normal'
        WHEN i.priority_id = 5  THEN 'Alta'
        WHEN i.priority_id = 14 THEN 'Muito Alta'
        WHEN i.priority_id = 17 THEN 'Crítica'
    END AS prioridade,

    TO_CHAR(st.start_date, 'DD/MM/YYYY') AS inicio_tarefa,
    TO_CHAR(st.due_date, 'DD/MM/YYYY') AS data_prevista_tarefa,
    st.done_ratio AS percentual_terminado_tarefa,
    st.description AS descricao_tarefa,

    /* ============================================================
       CAMPOS DID — TAREFA PAI
       ============================================================ */
    projeto_pai.value AS projeto_estrategico_tarefa,
    impedida_pai.value AS impedida_tarefa,

    /* ============================================================
       SUBTAREFA
       ============================================================ */
    i.id AS cod_subtarefa,
    i.subject AS subtarefa,
    TO_CHAR(i.created_on, 'DD/MM/YYYY') AS data_registro_subtarefa,
    s.name AS situacao_subtarefa,

    /* ============================================================
       CAMPOS DID — SUBTAREFA
       ============================================================ */
    projeto.value AS projeto_estrategico_subtarefa,
    impedida.value AS impedida_subtarefa,

    /* ============================================================
       ATRIBUÍDO PARA
       ============================================================ */
    u.login AS atribuido_para_matricula,
    u.firstname || ' ' || u.lastname AS atribuido_para_nome_completo,
    eu.address AS atribuido_para_email,

    /* ============================================================
       DATAS E PROGRESSO — SUBTAREFA
       ============================================================ */
    TO_CHAR(i.start_date, 'DD/MM/YYYY') AS inicio_subtarefa,
    TO_CHAR(i.due_date, 'DD/MM/YYYY') AS data_prevista_subtarefa,
    i.done_ratio AS percentual_terminado_subtarefa,
    i.description AS descricao_subtarefa

FROM public.issues i

/* ================================================================
   RELACIONAMENTOS PRINCIPAIS
   ================================================================ */
LEFT JOIN public.issues st
       ON st.id = i.parent_id

LEFT JOIN public.issue_statuses stp
       ON stp.id = st.status_id

LEFT JOIN public.projects p
       ON p.id = i.project_id

LEFT JOIN public.users u
       ON u.id = i.assigned_to_id

LEFT JOIN public.issue_statuses s
       ON s.id = i.status_id

LEFT JOIN public.trackers t
       ON t.id = i.tracker_id

LEFT JOIN public.email_addresses eu
       ON eu.user_id = i.assigned_to_id

/* ================================================================
   CAMPOS CUSTOMIZADOS — SUBTAREFA
   ================================================================ */
LEFT JOIN public.custom_values projeto
       ON projeto.customized_id = i.id
      AND projeto.customized_type = 'Issue'
      AND projeto.custom_field_id = 638

LEFT JOIN public.custom_values impedida
       ON impedida.customized_id = i.id
      AND impedida.customized_type = 'Issue'
      AND impedida.custom_field_id = 637

/* ================================================================
   CAMPOS CUSTOMIZADOS — TAREFA PAI
   ================================================================ */
LEFT JOIN public.custom_values projeto_pai
       ON projeto_pai.customized_id = st.id
      AND projeto_pai.customized_type = 'Issue'
      AND projeto_pai.custom_field_id = 638

LEFT JOIN public.custom_values impedida_pai
       ON impedida_pai.customized_id = st.id
      AND impedida_pai.customized_type = 'Issue'
      AND impedida_pai.custom_field_id = 637

/* ================================================================
   FILTROS OPCIONAIS
   ================================================================ */
-- WHERE
--     /* Filtrar por projeto/unidade */
--     p.id IN (?)
--
--     /* Filtrar por tarefa específica */
--     AND i.parent_id = ?
--
--     /* Filtrar por subtarefa específica */
--     AND i.id = ?

/* ================================================================
   ORDENAÇÃO
   ================================================================ */
ORDER BY
    cod_tarefa,
    data_registro_subtarefa ASC;