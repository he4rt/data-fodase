This is the structure from He4rt Bot 3.x which is based on PostgreSQL 16


```sql
create table public.migrations
(
    id        serial
        primary key,
    migration varchar(255) not null,
    batch     integer      not null
);

alter table public.migrations
    owner to postgres;

create table public.users
(
    id         uuid                  not null
        primary key,
    username   varchar(255)          not null
        constraint users_username_unique
            unique,
    name       varchar(255)          not null
        constraint users_name_unique
            unique,
    email      varchar(255),
    password   varchar(255),
    is_donator boolean default false not null,
    created_at timestamp(0),
    updated_at timestamp(0)
);

alter table public.users
    owner to postgres;

create table public.password_resets
(
    email      varchar(255) not null
        primary key,
    token      varchar(255) not null,
    created_at timestamp(0)
);

alter table public.password_resets
    owner to postgres;

create table public.failed_jobs
(
    id         bigserial
        primary key,
    uuid       varchar(255)                           not null
        constraint failed_jobs_uuid_unique
            unique,
    connection text                                   not null,
    queue      text                                   not null,
    payload    text                                   not null,
    exception  text                                   not null,
    failed_at  timestamp(0) default CURRENT_TIMESTAMP not null
);

alter table public.failed_jobs
    owner to postgres;

create table public.personal_access_tokens
(
    id             bigserial
        primary key,
    tokenable_type varchar(255) not null,
    tokenable_id   bigint       not null,
    name           varchar(255) not null,
    token          varchar(64)  not null
        constraint personal_access_tokens_token_unique
            unique,
    abilities      text,
    last_used_at   timestamp(0),
    expires_at     timestamp(0),
    created_at     timestamp(0),
    updated_at     timestamp(0)
);

alter table public.personal_access_tokens
    owner to postgres;

create index personal_access_tokens_tokenable_type_tokenable_id_index
    on public.personal_access_tokens (tokenable_type, tokenable_id);

create table public.meeting_types
(
    id         bigserial
        primary key,
    name       varchar(255) not null,
    week_day   integer      not null,
    start_at   time(0)      not null,
    created_at timestamp(0),
    updated_at timestamp(0)
);

comment on column public.meeting_types.week_day is 'Week day of event';

comment on column public.meeting_types.start_at is 'Number of minutes past midnight';

alter table public.meeting_types
    owner to postgres;

create table public.user_address
(
    id         uuid not null
        primary key,
    user_id    uuid not null
        constraint user_address_user_id_foreign
            references public.users
            on delete cascade,
    country    varchar(4),
    state      varchar(4),
    city       varchar(255),
    zip_code   varchar(255),
    created_at timestamp(0),
    updated_at timestamp(0)
);

alter table public.user_address
    owner to postgres;

create table public.user_information
(
    id           uuid not null
        primary key,
    user_id      uuid not null
        constraint user_information_user_id_foreign
            references public.users
            on delete cascade,
    name         varchar(255),
    nickname     varchar(255),
    linkedin_url varchar(255),
    github_url   varchar(255),
    birthdate    date,
    about        text,
    created_at   timestamp(0),
    updated_at   timestamp(0)
);

alter table public.user_information
    owner to postgres;

create table public.cache
(
    key        varchar(255) not null
        primary key,
    value      text         not null,
    expiration integer      not null
);

alter table public.cache
    owner to postgres;

create table public.cache_locks
(
    key        varchar(255) not null
        primary key,
    owner      varchar(255) not null,
    expiration integer      not null
);

alter table public.cache_locks
    owner to postgres;

create table public.sessions
(
    id            varchar(255) not null
        primary key,
    user_id       uuid,
    ip_address    varchar(45),
    user_agent    text,
    payload       text         not null,
    last_activity integer      not null
);

alter table public.sessions
    owner to postgres;

create index sessions_user_id_index
    on public.sessions (user_id);

create index sessions_last_activity_index
    on public.sessions (last_activity);

create table public.notifications
(
    id              uuid         not null
        primary key,
    type            varchar(255) not null,
    notifiable_type varchar(255) not null,
    notifiable_id   bigint       not null,
    data            text         not null,
    read_at         timestamp(0),
    created_at      timestamp(0),
    updated_at      timestamp(0)
);

alter table public.notifications
    owner to postgres;

create index notifications_notifiable_type_notifiable_id_index
    on public.notifications (notifiable_type, notifiable_id);

create table public.job_batches
(
    id             varchar(255) not null
        primary key,
    name           varchar(255) not null,
    total_jobs     integer      not null,
    pending_jobs   integer      not null,
    failed_jobs    integer      not null,
    failed_job_ids text         not null,
    options        text,
    cancelled_at   integer,
    created_at     integer      not null,
    finished_at    integer
);

alter table public.job_batches
    owner to postgres;

create table public.jobs
(
    id           bigserial
        primary key,
    queue        varchar(255) not null,
    payload      text         not null,
    attempts     smallint     not null,
    reserved_at  integer,
    available_at integer      not null,
    created_at   integer      not null
);

alter table public.jobs
    owner to postgres;

create index jobs_queue_index
    on public.jobs (queue);

create table public.tenants
(
    id         bigserial
        primary key,
    name       varchar(255) not null,
    slug       varchar(255) not null,
    owner_id   uuid         not null
        constraint tenants_owner_id_foreign
            references public.users,
    active     boolean      not null,
    created_at timestamp(0),
    updated_at timestamp(0),
    deleted_at timestamp(0)
);

alter table public.tenants
    owner to postgres;

create table public.meetings
(
    id              uuid         not null
        primary key,
    admin_id        uuid         not null
        constraint meetings_admin_id_foreign
            references public.users
            on delete cascade,
    content         text,
    meeting_type_id bigint       not null
        constraint meetings_meeting_type_id_foreign
            references public.meeting_types
            on delete cascade,
    starts_at       timestamp(0) not null,
    ends_at         timestamp(0),
    created_at      timestamp(0),
    updated_at      timestamp(0),
    tenant_id       bigint       not null
        constraint meetings_tenant_id_foreign
            references public.tenants
            on delete set null
);

alter table public.meetings
    owner to postgres;

create table public.meeting_participants
(
    meeting_id uuid         not null
        constraint meeting_participants_meeting_id_foreign
            references public.meetings
            on delete cascade,
    user_id    uuid         not null
        constraint meeting_participants_user_id_foreign
            references public.users
            on delete cascade,
    attend_at  timestamp(0) not null,
    created_at timestamp(0),
    updated_at timestamp(0)
);

alter table public.meeting_participants
    owner to postgres;

create table public.characters
(
    id                     uuid              not null
        primary key,
    user_id                uuid              not null
        constraint characters_user_id_foreign
            references public.users
            on delete cascade,
    experience             integer default 0 not null,
    reputation             integer default 0 not null,
    daily_bonus_claimed_at timestamp(0),
    created_at             timestamp(0),
    updated_at             timestamp(0),
    tenant_id              bigint            not null
        constraint characters_tenant_id_foreign
            references public.tenants
            on delete set null
);

alter table public.characters
    owner to postgres;

create table public.providers
(
    id          uuid         not null
        primary key,
    model_id    varchar(255),
    provider    varchar(255) not null,
    provider_id varchar(255) not null,
    email       varchar(255),
    created_at  timestamp(0),
    updated_at  timestamp(0),
    model_type  varchar(255) default 'He4rt\User\Models\User'::character varying,
    tenant_id   bigint       not null
        constraint providers_tenant_id_foreign
            references public.tenants
            on delete set null
);

alter table public.providers
    owner to postgres;

create index providers_model_type_model_id_index
    on public.providers (model_type, model_id);

create index providers_tenant_id_model_type_model_id_index
    on public.providers (tenant_id, model_type, model_id);

create table public.messages
(
    id                  uuid    not null
        primary key,
    provider_id         uuid    not null
        constraint messages_provider_id_foreign
            references public.providers,
    provider_message_id varchar(255),
    season_id           integer not null,
    channel_id          varchar(255),
    content             text    not null,
    obtained_experience integer not null,
    sent_at             timestamp(0),
    created_at          timestamp(0),
    updated_at          timestamp(0),
    tenant_id           bigint  not null
        constraint messages_tenant_id_foreign
            references public.tenants
            on delete set null
);

alter table public.messages
    owner to postgres;

create table public.badges
(
    id          bigserial
        primary key,
    provider    varchar(255) not null,
    name        varchar(255) not null,
    description text         not null,
    redeem_code varchar(255) not null,
    active      boolean      not null,
    created_at  timestamp(0),
    updated_at  timestamp(0),
    tenant_id   bigint       not null
        constraint badges_tenant_id_foreign
            references public.tenants
            on delete set null
);

alter table public.badges
    owner to postgres;

create table public.characters_badges
(
    character_id uuid         not null
        constraint characters_badges_character_id_foreign
            references public.characters
            on delete cascade,
    badge_id     bigint       not null
        constraint characters_badges_badge_id_foreign
            references public.badges
            on delete cascade,
    claimed_at   timestamp(0) not null,
    tenant_id    bigint       not null
        constraint characters_badges_tenant_id_foreign
            references public.tenants
            on delete set null
);

alter table public.characters_badges
    owner to postgres;

create table public.seasons_rankings
(
    id               uuid         not null
        primary key,
    season_id        varchar(255) not null,
    character_id     uuid         not null
        constraint seasons_rankings_character_id_foreign
            references public.characters
            on delete cascade,
    ranking_position integer      not null,
    level            integer      not null,
    experience       integer      not null,
    messages_count   integer      not null,
    badges_count     integer      not null,
    meetings_count   integer      not null,
    created_at       timestamp(0),
    updated_at       timestamp(0),
    tenant_id        bigint       not null
        constraint seasons_rankings_tenant_id_foreign
            references public.tenants
            on delete set null
);

alter table public.seasons_rankings
    owner to postgres;

create table public.feedbacks
(
    id         uuid         not null
        primary key,
    sender_id  uuid         not null
        constraint feedbacks_sender_id_foreign
            references public.users
            on delete cascade,
    target_id  uuid         not null
        constraint feedbacks_target_id_foreign
            references public.users
            on delete cascade,
    type       varchar(255) not null,
    message    text         not null,
    created_at timestamp(0),
    updated_at timestamp(0),
    tenant_id  bigint       not null
        constraint feedbacks_tenant_id_foreign
            references public.tenants
            on delete set null
);

alter table public.feedbacks
    owner to postgres;

create table public.feedback_reviews
(
    id          uuid         not null
        primary key,
    feedback_id uuid         not null
        constraint feedback_reviews_feedback_id_foreign
            references public.feedbacks
            on delete cascade,
    staff_id    uuid         not null
        constraint feedback_reviews_staff_id_foreign
            references public.users
            on delete cascade,
    status      varchar(255) not null,
    reason      text,
    received_at timestamp(0) not null,
    created_at  timestamp(0),
    updated_at  timestamp(0),
    tenant_id   bigint       not null
        constraint feedback_reviews_tenant_id_foreign
            references public.tenants
            on delete set null
);

alter table public.feedback_reviews
    owner to postgres;

create table public.seasons
(
    id                 uuid              not null,
    name               varchar(255)      not null,
    description        text              not null,
    started_at         timestamp(0),
    ended_at           timestamp(0),
    messages_count     integer default 0 not null,
    participants_count integer default 0 not null,
    meeting_count      integer default 0 not null,
    badges_count       integer default 0 not null,
    created_at         timestamp(0),
    updated_at         timestamp(0),
    tenant_id          bigint            not null
        constraint seasons_tenant_id_foreign
            references public.tenants
            on delete set null
);

alter table public.seasons
    owner to postgres;

create table public.characters_leveling_logs
(
    id           uuid    not null
        primary key,
    season_id    integer not null,
    character_id uuid    not null
        constraint characters_leveling_logs_character_id_foreign
            references public.characters,
    level        integer not null,
    created_at   timestamp(0),
    updated_at   timestamp(0)
);

alter table public.characters_leveling_logs
    owner to postgres;

create table public.voice_messages
(
    id                  bigserial
        primary key,
    provider_id         uuid         not null
        constraint voice_messages_provider_id_foreign
            references public.providers,
    season_id           integer      not null,
    channel_name        varchar(255) not null,
    state               varchar(255) not null,
    obtained_experience integer      not null,
    created_at          timestamp(0),
    updated_at          timestamp(0),
    tenant_id           bigint       not null
        constraint voice_messages_tenant_id_foreign
            references public.tenants
            on delete set null
);

alter table public.voice_messages
    owner to postgres;

create table public.media
(
    id                    bigserial
        primary key,
    model_type            varchar(255) not null,
    model_id              bigint       not null,
    uuid                  uuid
        constraint media_uuid_unique
            unique,
    collection_name       varchar(255) not null,
    name                  varchar(255) not null,
    file_name             varchar(255) not null,
    mime_type             varchar(255),
    disk                  varchar(255) not null,
    conversions_disk      varchar(255),
    size                  bigint       not null,
    manipulations         json         not null,
    custom_properties     json         not null,
    generated_conversions json         not null,
    responsive_images     json         not null,
    order_column          integer,
    created_at            timestamp(0),
    updated_at            timestamp(0)
);

alter table public.media
    owner to postgres;

create index media_model_type_model_id_index
    on public.media (model_type, model_id);

create index media_order_column_index
    on public.media (order_column);

create table public.events
(
    id              bigserial
        primary key,
    tenant_id       bigint            not null
        constraint events_tenant_id_foreign
            references public.tenants
            on delete set null,
    event_type      varchar(255)      not null,
    active          boolean           not null,
    slug            varchar(255)      not null,
    title           varchar(255)      not null,
    description     text              not null,
    event_at        timestamp(0)      not null,
    start_at        timestamp(0)      not null,
    end_at          timestamp(0)      not null,
    location        varchar(255)      not null,
    max_attendees   integer           not null,
    attendees_count integer default 0 not null,
    waitlist_count  integer default 0 not null,
    created_at      timestamp(0),
    updated_at      timestamp(0)
);

alter table public.events
    owner to postgres;

create table public.events_talks
(
    id          bigserial
        primary key,
    event_id    bigint       not null
        constraint events_talks_event_id_foreign
            references public.events
            on delete cascade,
    user_id     uuid         not null
        constraint events_talks_user_id_foreign
            references public.users
            on delete cascade,
    tenant_id   bigint       not null
        constraint events_talks_tenant_id_foreign
            references public.tenants
            on delete set null,
    status      varchar(255) not null,
    field_type  varchar(255) not null,
    title       varchar(255) not null,
    description text         not null,
    starts_at   timestamp(0) not null,
    ends_at     timestamp(0) not null,
    created_at  timestamp(0),
    updated_at  timestamp(0)
);

alter table public.events_talks
    owner to postgres;

create table public.events_attendees
(
    event_id   bigint       not null
        constraint events_attendees_event_id_foreign
            references public.events
            on delete cascade,
    user_id    uuid         not null
        constraint events_attendees_user_id_foreign
            references public.users
            on delete cascade,
    status     varchar(255) not null,
    created_at timestamp(0),
    updated_at timestamp(0)
);

alter table public.events_attendees
    owner to postgres;

create table public.sponsors
(
    id           bigserial
        primary key,
    tenant_id    bigint       not null
        constraint sponsors_tenant_id_foreign
            references public.tenants
            on delete set null,
    name         varchar(255) not null,
    homepage_url varchar(255),
    created_at   timestamp(0),
    updated_at   timestamp(0)
);

alter table public.sponsors
    owner to postgres;

create table public.events_sponsors
(
    event_id   bigint       not null
        constraint events_sponsors_event_id_foreign
            references public.events
            on delete cascade,
    sponsor_id bigint       not null
        constraint events_sponsors_sponsor_id_foreign
            references public.sponsors
            on delete cascade,
    level      varchar(255) not null,
    created_at timestamp(0),
    updated_at timestamp(0)
);

alter table public.events_sponsors
    owner to postgres;

create table public.provider_tokens
(
    id            uuid         not null
        primary key,
    provider_id   uuid         not null
        constraint provider_tokens_provider_id_foreign
            references public.providers
            on delete cascade,
    access_token  varchar(255) not null,
    refresh_token varchar(255) not null,
    expires_in    integer,
    created_at    timestamp(0),
    updated_at    timestamp(0)
);

alter table public.provider_tokens
    owner to postgres;

create table public.tenant_users
(
    tenant_id  bigint not null
        constraint tenant_users_tenant_id_foreign
            references public.tenants
            on delete cascade,
    user_id    uuid   not null
        constraint tenant_users_user_id_foreign
            references public.users
            on delete cascade,
    created_at timestamp(0),
    updated_at timestamp(0)
);

alter table public.tenant_users
    owner to postgres;

create table public.characters_wallet
(
    id           bigserial
        primary key,
    balance      integer default 0 not null,
    character_id uuid              not null
        constraint characters_wallet_character_id_foreign
            references public.characters
            on delete cascade,
    created_at   timestamp(0) with time zone,
    updated_at   timestamp(0) with time zone
);

alter table public.characters_wallet
    owner to postgres;

```