<template>
    <div id="welcome" class="text-center">
        <flash-message></flash-message>
        <h1 class="mt-5">{{ $t("root.welcome") }}</h1>
        <div class="container">
            <button @click="createChat()" type="button" class="btn btn-primary">{{ $t("root.create_chat") }}</button>
            <button @click="joinRandomChat()" type="button" class="btn btn-danger">{{ $t("root.join_random_chat") }}</button>
        </div>
        {{ enterBySessionToken() }}
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
                        this.flash(this.$t('flash.session_token_exists'), 'alert alert-danger')
                    }
                });
            },
            joinRandomChat() {
                this.$http.post('/chats/join_random',
                    {session_token: gon.session_token}
                ).then(response => {
                    if (!response.body.session_token_unique) {
                        this.flash(this.$t('flash.session_token_exists'), 'alert alert-danger')
                        return
                    }
                    if (response.body.free_chat_found) {
                        this.$router.push(`/chats/${response.body.chat_token}`)
                        Rollbar.info("JS: Join a random chat")
                    } else {
                        this.flash(this.$t('flash.no_empty_chats'), 'alert alert-primary')
                    }
                });
            }
        }
    }
</script>
