<template>
    <div id="welcome">
        {{ enterBySessionToken() }}
        <flash-message></flash-message>
        <h1>{{ $t("root.welcome") }}</h1>
        <button @click="createChat()">{{ $t("root.create_chat") }}</button>
        <button @click="joinRandomChat()">{{ $t("root.join_random_chat") }}</button>
    </div>
</template>

<script>
    export default {
        methods: {
            enterBySessionToken() {
                let session_token = localStorage.getItem('session_token')
                if (session_token !== null) {
                    this.$http.post('/chats/enter_by_session_token',
                        {session_token: session_token}
                    ).then(response => {
                        if (response.body.session_token_found) {
                            this.$router.push(`/chats/${response.body.chat_token}`)
                            Rollbar.info("JS: Enter to chat by session token")
                        } else {
                            this.rewriteSessionTokenInLocalStorage()
                        }
                    });
                } else {
                    this.rewriteSessionTokenInLocalStorage()
                }
            },
            rewriteSessionTokenInLocalStorage() {
                localStorage.removeItem('session_token')
                localStorage.setItem('session_token', gon.session_token)
                Rollbar.info("JS: Rewrite session token in local storage")
            },
            createChat() {
                this.$http.post('/chats',
                    {session_token: gon.session_token}
                ).then(response => {
                    if (response.body.session_token_unique) {
                        this.$router.push(`/chats/${response.body.chat_token}`)
                        Rollbar.info("JS: Create a chat")
                    } else {
                        this.flash(this.$t('flash.session_token_exists'), 'error')
                    }
                });
            },
            joinRandomChat() {
                this.$http.post('/chats/join_random',
                    {session_token: gon.session_token}
                ).then(response => {
                    if (!response.body.session_token_unique) {
                        this.flash(this.$t('flash.session_token_exists'), 'error')
                        return
                    }
                    if (response.body.free_chat_found) {
                        this.$router.push(`/chats/${response.body.chat_token}`)
                        Rollbar.info("JS: Join a random chat")
                    } else {
                        this.flash(this.$t('flash.no_empty_chats'), 'warning')
                    }
                });
            }
        }
    }
</script>
