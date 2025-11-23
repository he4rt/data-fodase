This is the structure from He4rt Bot 2.x which is based on MySql 8.0




```sql
create table dev_he4rt.badges
(
    id          bigint unsigned auto_increment
        primary key,
    provider    varchar(255) not null,
    name        varchar(255) not null,
    description text         not null,
    image_url   varchar(255) not null,
    redeem_code varchar(255) not null,
    active      tinyint(1)   not null,
    created_at  timestamp    null,
    updated_at  timestamp    null
)
    collate = utf8mb4_unicode_ci;

create table dev_he4rt.failed_jobs
(
    id         bigint unsigned auto_increment
        primary key,
    uuid       varchar(255)                        not null,
    connection text                                not null,
    queue      text                                not null,
    payload    longtext                            not null,
    exception  longtext                            not null,
    failed_at  timestamp default CURRENT_TIMESTAMP not null,
    constraint failed_jobs_uuid_unique
        unique (uuid)
)
    collate = utf8mb4_unicode_ci;

create table dev_he4rt.meeting_types
(
    id         bigint unsigned auto_increment
        primary key,
    name       varchar(255) not null,
    week_day   int          not null comment 'Week day of event',
    start_at   int          not null comment 'Number of minutes past midnight',
    created_at timestamp    null,
    updated_at timestamp    null
)
    collate = utf8mb4_unicode_ci;

create table dev_he4rt.migrations
(
    id        int unsigned auto_increment
        primary key,
    migration varchar(255) not null,
    batch     int          not null
)
    collate = utf8mb4_unicode_ci;

create table dev_he4rt.password_resets
(
    email      varchar(255) not null
        primary key,
    token      varchar(255) not null,
    created_at timestamp    null
)
    collate = utf8mb4_unicode_ci;

create table dev_he4rt.personal_access_tokens
(
    id             bigint unsigned auto_increment
        primary key,
    tokenable_type varchar(255)    not null,
    tokenable_id   bigint unsigned not null,
    name           varchar(255)    not null,
    token          varchar(64)     not null,
    abilities      text            null,
    last_used_at   timestamp       null,
    expires_at     timestamp       null,
    created_at     timestamp       null,
    updated_at     timestamp       null,
    constraint personal_access_tokens_token_unique
        unique (token)
)
    collate = utf8mb4_unicode_ci;

create index personal_access_tokens_tokenable_type_tokenable_id_index
    on dev_he4rt.personal_access_tokens (tokenable_type, tokenable_id);

create table dev_he4rt.seasons
(
    id                 char(36)      not null,
    name               varchar(255)  not null,
    description        text          not null,
    started_at         timestamp     null,
    ended_at           timestamp     null,
    messages_count     int default 0 not null,
    participants_count int default 0 not null,
    meeting_count      int default 0 not null,
    badges_count       int default 0 not null,
    created_at         timestamp     null,
    updated_at         timestamp     null
)
    collate = utf8mb4_unicode_ci;

create table dev_he4rt.users
(
    id         char(36)             not null
        primary key,
    username   varchar(255)         not null,
    is_donator tinyint(1) default 0 not null,
    created_at timestamp            null,
    updated_at timestamp            null,
    constraint users_username_unique
        unique (username)
)
    collate = utf8mb4_unicode_ci;

create table dev_he4rt.characters
(
    id                     char(36)      not null
        primary key,
    user_id                char(36)      not null,
    experience             int default 0 not null,
    reputation             int default 0 not null,
    daily_bonus_claimed_at timestamp     null,
    created_at             timestamp     null,
    updated_at             timestamp     null,
    constraint characters_user_id_foreign
        foreign key (user_id) references dev_he4rt.users (id)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;

create table dev_he4rt.characters_badges
(
    character_id char(36)        not null,
    badge_id     bigint unsigned not null,
    claimed_at   timestamp       not null,
    constraint characters_badges_badge_id_foreign
        foreign key (badge_id) references dev_he4rt.badges (id)
            on delete cascade,
    constraint characters_badges_character_id_foreign
        foreign key (character_id) references dev_he4rt.characters (id)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;

create table dev_he4rt.characters_leveling_logs
(
    id           char(36)  not null
        primary key,
    season_id    int       not null,
    character_id char(36)  not null,
    level        int       not null,
    created_at   timestamp null,
    updated_at   timestamp null,
    constraint characters_leveling_logs_character_id_foreign
        foreign key (character_id) references dev_he4rt.characters (id)
)
    collate = utf8mb4_unicode_ci;

create table dev_he4rt.feedbacks
(
    id         char(36)     not null
        primary key,
    sender_id  char(36)     not null,
    target_id  char(36)     not null,
    type       varchar(255) not null,
    message    text         not null,
    created_at timestamp    null,
    updated_at timestamp    null,
    constraint feedbacks_sender_id_foreign
        foreign key (sender_id) references dev_he4rt.users (id)
            on delete cascade,
    constraint feedbacks_target_id_foreign
        foreign key (target_id) references dev_he4rt.users (id)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;

create table dev_he4rt.feedback_reviews
(
    id          char(36)     not null
        primary key,
    feedback_id char(36)     not null,
    staff_id    char(36)     not null,
    status      varchar(255) not null,
    reason      text         null,
    received_at timestamp    not null,
    created_at  timestamp    null,
    updated_at  timestamp    null,
    constraint feedback_reviews_feedback_id_foreign
        foreign key (feedback_id) references dev_he4rt.feedbacks (id)
            on delete cascade,
    constraint feedback_reviews_staff_id_foreign
        foreign key (staff_id) references dev_he4rt.users (id)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;

create table dev_he4rt.meetings
(
    id              char(36)        not null
        primary key,
    admin_id        char(36)        not null,
    content         text            null,
    meeting_type_id bigint unsigned not null,
    starts_at       datetime        not null,
    ends_at         datetime        null,
    created_at      timestamp       null,
    updated_at      timestamp       null,
    constraint meetings_admin_id_foreign
        foreign key (admin_id) references dev_he4rt.users (id)
            on delete cascade,
    constraint meetings_meeting_type_id_foreign
        foreign key (meeting_type_id) references dev_he4rt.meeting_types (id)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;

create table dev_he4rt.meeting_participants
(
    meeting_id char(36)  not null,
    user_id    char(36)  not null,
    attend_at  datetime  not null,
    created_at timestamp null,
    updated_at timestamp null,
    constraint meeting_participants_meeting_id_foreign
        foreign key (meeting_id) references dev_he4rt.meetings (id)
            on delete cascade,
    constraint meeting_participants_user_id_foreign
        foreign key (user_id) references dev_he4rt.users (id)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;

create table dev_he4rt.providers
(
    id          char(36)     not null
        primary key,
    user_id     char(36)     not null,
    provider    varchar(255) not null,
    provider_id varchar(255) not null,
    email       varchar(255) null,
    created_at  timestamp    null,
    updated_at  timestamp    null,
    constraint providers_user_id_foreign
        foreign key (user_id) references dev_he4rt.users (id)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;

create table dev_he4rt.messages
(
    id                  char(36)     not null
        primary key,
    provider_id         char(36)     not null,
    provider_message_id varchar(255) null,
    season_id           int          not null,
    channel_id          varchar(255) null,
    content             text         not null,
    obtained_experience int          not null,
    sent_at             timestamp    null,
    created_at          timestamp    null,
    updated_at          timestamp    null,
    constraint messages_provider_id_foreign
        foreign key (provider_id) references dev_he4rt.providers (id)
)
    collate = utf8mb4_unicode_ci;

create table dev_he4rt.seasons_rankings
(
    id               char(36)     not null
        primary key,
    season_id        varchar(255) not null,
    character_id     char(36)     not null,
    ranking_position int          not null,
    level            int          not null,
    experience       int          not null,
    messages_count   int          not null,
    badges_count     int          not null,
    meetings_count   int          not null,
    created_at       timestamp    null,
    updated_at       timestamp    null,
    constraint seasons_rankings_character_id_foreign
        foreign key (character_id) references dev_he4rt.characters (id)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;

create table dev_he4rt.user_address
(
    id         char(36)     not null
        primary key,
    user_id    char(36)     not null,
    country    varchar(4)   null,
    state      varchar(4)   null,
    city       varchar(255) null,
    zip_code   varchar(255) null,
    created_at timestamp    null,
    updated_at timestamp    null,
    constraint user_address_user_id_foreign
        foreign key (user_id) references dev_he4rt.users (id)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;

create table dev_he4rt.user_information
(
    id           char(36)     not null
        primary key,
    user_id      char(36)     not null,
    name         varchar(255) null,
    nickname     varchar(255) null,
    linkedin_url varchar(255) null,
    github_url   varchar(255) null,
    birthdate    date         null,
    about        text         null,
    created_at   timestamp    null,
    updated_at   timestamp    null,
    constraint user_information_user_id_foreign
        foreign key (user_id) references dev_he4rt.users (id)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;

create table dev_he4rt.voice_messages
(
    id                  bigint unsigned auto_increment
        primary key,
    provider_id         char(36)     not null,
    season_id           int          not null,
    channel_name        varchar(255) not null,
    state               varchar(255) not null,
    obtained_experience int          not null,
    created_at          timestamp    null,
    updated_at          timestamp    null,
    constraint voice_messages_provider_id_foreign
        foreign key (provider_id) references dev_he4rt.providers (id)
)
    collate = utf8mb4_unicode_ci;

```