<template>
    <div id="welcome">
        <h1>{{ t_welcome }}</h1>
        <form class="new_chat" id="new_chat" action="/chats" accept-charset="UTF-8" method="post">
            <input name="utf8" type="hidden" value="&#x2713;" />
            <input type="hidden" name="authenticity_token" :value="authenticity_token" />
            <input name="session_token" type="hidden" :value="session_token" />
            <input type="submit" name="commit" value="Создать чат" data-disable-with="Создать чат" />
        </form>
        <form action="/chats/join_random" accept-charset="UTF-8" method="post">
            <input name="utf8" type="hidden" value="&#x2713;" />
            <input type="hidden" name="authenticity_token" :value="authenticity_token" />
            <input name="session_token" type="hidden" :value="session_token" />
            <input type="submit" name="commit" value="Присоединиться к случайному чату" data-disable-with="Присоединиться к случайному чату" />
        </form>
        {{ rewriteSessionTokenInLocalStorage() }}
    </div>
</template>

<script>
    export default {
        data() {
            return {
                t_welcome: gon.t_welcome,
                session_token: gon.session_token,
                authenticity_token: gon.csrf
            }
        },
        methods: {
            rewriteSessionTokenInLocalStorage() {
                localStorage.removeItem('session_token')
                localStorage.setItem('session_token', this.session_token)
            }
        }
    }
</script>