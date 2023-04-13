{{
  config(
    materialized=env_var('DBT_MAT_VIEW'),
    on_schema_change='sync_all_columns',
    enabled=true
  )
}}

with repository as (
select * 
from {{ ref('src_repository') }} 
)
, commit as (  
select * 
from {{ ref('src_commit') }} 
)
, pull_request  as (  
select * 
from {{ ref('src_pull_request') }} 
)
, commit_pull_request  as (  
select * 
from {{ ref('src_commit_pull_request') }} 
)
, pull_request_review  as (  
select * 
from {{ ref('src_pull_request_review') }}  a
where exists (select id from (select max(id) id from {{ ref('src_pull_request_review') }}  group by pull_request_id) b where a.id = b.id)
)
--- pull request
, issue as (  
select * 
from {{ ref('src_issue') }} 
)
, issue_merged  as (
select * 
from {{ ref('src_issue_merged') }} 
)
, issue_closed_history  as (
select * 
from {{ ref('src_issue_closed_history') }} 
)
, issue_assignee  as (
select * 
from {{ ref('src_issue_assignee') }} 
)
, issue_comment  as (
select * 
from {{ ref('src_issue_comment') }} 
)
, user as (
select * 
from {{ ref('src_user') }} 
)
, user_email as (
select * from (
              select *, row_number() over (partition by user_id order by email desc) rw
              from {{ ref('src_user_email') }} 
              ) 
where rw = 1
)
select distinct
  repository.name as repository_name
, repository.full_name as repository_full_name
, repository.description as repository_description
, repository.default_branch as repository_default_branch
, repository.created_at as repository_created_at
, repository.private as repository_private
, commit.message as commit_message
, commit.committer_date as commit_date
, commit.sha as commit_sha
, commit.committer_email as committer_email
, commit.committer_name as committer_name

, commit_user.id as commit_user_id
, commit_user.login as commit_user_login
--, commit_user.name as commit_user_name
--, commit_user_email.email as commit_user_email

, issue.id as issue_id
, issue.created_at as issue_created_at
, issue.updated_at as issue_updated_at
, issue.number as issue_number
, issue.state as issue_state
, issue.title as issue_title
, issue.body as issue_body
, issue.user_id as issue_created_by
--, issue.closed_at as issue_closed_at

--, assigned_user.email as assigned_user_email
--, assigned_user.name as assigned_user_name

, issue_comment.body as issue_comment_body
, issue_comment.created_at as issue_comment_created_at
, issue_comment.updated_at as issue_comment_updated_at
, comment_user.email as comment_user_email
, comment_user.name as comment_user_name


, pull_request.id as pull_request_id
, pull_request.merge_commit_sha as pull_request_merge_commit_sha
, pull_request.draft as pull_request_draft
, pull_request.head_ref as pull_request_head_ref
, pull_request.head_sha as pull_request_head_sha
, pull_request.head_user_id as pull_request_head_user_id
, pull_request.base_ref as pull_request_base_ref
, pull_request.base_sha as pull_request_base_sha
, pull_request.base_user_id as pull_request_base_user_id

, pull_request_review.body as pull_request_review_body
, pull_request_review.state as pull_request_review_state
, pull_request_review.submitted_at as pull_request_review_submitted_at

, review_user.email as review_user_email
, review_user.name as review_user_name
, review_user.user_id as review_user_id


, issue_merged.merged_at as issue_merged_at
, issue_merged.actor_id as issue_merged_by_id
, issue_closed_history.closed as issue_closed
, issue_closed_history.updated_at as issue_closed_at
, issue_closed_history.actor_id as issue_closed_by_id
, issue_merged.commit_sha as issue_merged_commit_sha

from issue

left join issue_comment on issue_comment.issue_id = issue.id
left join user_email comment_user on comment_user.user_id = issue_comment.user_id
left join issue_closed_history on issue_closed_history.issue_id = issue.id --and issue_closed_history.commit_sha  = commit.sha

left join repository on repository.id = issue.repository_id
left join pull_request on pull_request.base_repo_id = repository.id and pull_request.issue_id = issue.id 
left join commit_pull_request on commit_pull_request.pull_request_id = pull_request.id


left join commit on repository.id = commit.repository_id and commit_pull_request.commit_sha = commit.sha
left join issue_merged on issue_merged.issue_id = issue.id --and issue_merged.commit_sha  = commit.sha
left join user_email commit_user_email on commit_user_email.email = commit.committer_email
left join user commit_user on commit_user.id = commit_user_email.user_id


left join pull_request_review on pull_request_review.pull_request_id = pull_request.id
left join commit review_commit on review_commit.repository_id  = repository.id and review_commit.sha = pull_request_review.commit_sha
left join user_email review_user on review_user.user_id = pull_request_review.user_id


--left join issue_assignee on issue_assignee.issue_id = issue.id
--left join user_email assigned_user on issue_assignee.user_id = assigned_user.user_id

where lower(REPOSITORY.NAME) = '{{env_var('DBT_SRC_SCHEMA')}}'
