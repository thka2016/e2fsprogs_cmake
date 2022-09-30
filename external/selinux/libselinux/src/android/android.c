#include "android_common.h"

#ifdef __ANDROID_VNDK__
#ifndef LOG_EVENT_STRING
#define LOG_EVENT_STRING(...)
#endif  // LOG_EVENT_STRING
#endif  // __ANDROID_VNDK__

static const char* const service_context_paths[MAX_CONTEXT_PATHS][MAX_ALT_CONTEXT_PATHS] = {
	{
		"/system/etc/selinux/plat_service_contexts",
		"/plat_service_contexts"
	},
	{
		"/dev/selinux/apex_service_contexts"
	},
	{
		"/system_ext/etc/selinux/system_ext_service_contexts",
		"/system_ext_service_contexts"
	},
	{
		"/product/etc/selinux/product_service_contexts",
		"/product_service_contexts"
	},
	{
		"/vendor/etc/selinux/vendor_service_contexts",
		"/vendor_service_contexts"
	}
};

static const char* const hwservice_context_paths[MAX_CONTEXT_PATHS][MAX_ALT_CONTEXT_PATHS] = {
	{
		"/system/etc/selinux/plat_hwservice_contexts",
		"/plat_hwservice_contexts"
	},
	{
		"/system_ext/etc/selinux/system_ext_hwservice_contexts",
		"/system_ext_hwservice_contexts"
	},
	{
		"/product/etc/selinux/product_hwservice_contexts",
		"/product_hwservice_contexts"
	},
	{
		"/vendor/etc/selinux/vendor_hwservice_contexts",
		"/vendor_hwservice_contexts"
	},
	{
		"/odm/etc/selinux/odm_hwservice_contexts",
		"/odm_hwservice_contexts"
	},
};

static const char* const vndservice_context_paths[MAX_CONTEXT_PATHS][MAX_ALT_CONTEXT_PATHS] = {
	{
		"/vendor/etc/selinux/vndservice_contexts",
		"/vndservice_contexts"
	}
};

static const char* const keystore2_context_paths[MAX_CONTEXT_PATHS][MAX_ALT_CONTEXT_PATHS] = {
	{
		"/system/etc/selinux/plat_keystore2_key_contexts",
		"/plat_keystore2_key_contexts"
	},
	{
		"/system_ext/etc/selinux/system_ext_keystore2_key_contexts",
		"/system_ext_keystore2_key_contexts"
	},
	{
		"/product/etc/selinux/product_keystore2_key_contexts",
		"/product_keystore2_key_contexts"
	},
	{
		"/vendor/etc/selinux/vendor_keystore2_key_contexts",
		"/vendor_keystore2_key_contexts"
	}
};

size_t find_existing_files(
		const char* const path_sets[MAX_CONTEXT_PATHS][MAX_ALT_CONTEXT_PATHS],
		const char* paths[MAX_CONTEXT_PATHS])
{
	size_t i, j, len = 0;
	for (i = 0; i < MAX_CONTEXT_PATHS; i++) {
		for (j = 0; j < MAX_ALT_CONTEXT_PATHS; j++) {
			const char* file = path_sets[i][j];
			if (file && access(file, R_OK) != -1) {
				paths[len++] = file;
				/* Within each set, only the first valid entry is used */
				break;
			}
		}
	}
	return len;
}

void paths_to_opts(const char* paths[MAX_CONTEXT_PATHS],
		size_t npaths,
		struct selinux_opt* const opts)
{
	for (size_t i = 0; i < npaths; i++) {
		opts[i].type = SELABEL_OPT_PATH;
		opts[i].value = paths[i];
	}
}

struct selabel_handle* initialize_backend(
		unsigned int backend,
		const char* name,
		const struct selinux_opt* opts,
		size_t nopts)
{
		struct selabel_handle* sehandle;

		sehandle = selabel_open(backend, opts, nopts);

		if (!sehandle) {
				selinux_log(SELINUX_ERROR, "%s: Error getting %s handle (%s)\n",
								__FUNCTION__, name, strerror(errno));
				return NULL;
		}
		selinux_log(SELINUX_INFO, "SELinux: Loaded %s context from:\n", name);
		for (unsigned i = 0; i < nopts; i++) {
			if (opts[i].type == SELABEL_OPT_PATH)
				selinux_log(SELINUX_INFO, "		%s\n", opts[i].value);
		}
		return sehandle;
}

struct selabel_handle* context_handle(
		unsigned int backend,
		const char* const context_paths[MAX_CONTEXT_PATHS][MAX_ALT_CONTEXT_PATHS],
		const char* name)
{
	const char* existing_paths[MAX_CONTEXT_PATHS];
	struct selinux_opt opts[MAX_CONTEXT_PATHS];
	int size = 0;

	size = find_existing_files(context_paths, existing_paths);
	paths_to_opts(existing_paths, size, opts);

	return initialize_backend(backend, name, opts, size);
}

struct selabel_handle* selinux_android_service_context_handle(void)
{
	return context_handle(SELABEL_CTX_ANDROID_SERVICE, service_context_paths, "service");
}

struct selabel_handle* selinux_android_hw_service_context_handle(void)
{
	return context_handle(SELABEL_CTX_ANDROID_SERVICE, hwservice_context_paths, "hwservice");
}

struct selabel_handle* selinux_android_vendor_service_context_handle(void)
{
	return context_handle(SELABEL_CTX_ANDROID_SERVICE, vndservice_context_paths, "vndservice");
}

struct selabel_handle* selinux_android_keystore2_key_context_handle(void)
{
	return context_handle(SELABEL_CTX_ANDROID_KEYSTORE2_KEY, keystore2_context_paths, "keystore2");
}

int selinux_log_callback(int type, const char *fmt, ...)
{
    va_list ap;
    int priority;
    char *strp;

    switch(type) {
    case SELINUX_WARNING:
        priority = ANDROID_LOG_WARN;
        break;
    case SELINUX_INFO:
        priority = ANDROID_LOG_INFO;
        break;
    default:
        priority = ANDROID_LOG_ERROR;
        break;
    }

    va_start(ap, fmt);
    if (vasprintf(&strp, fmt, ap) != -1) {
        LOG_PRI(priority, "SELinux", "%s", strp);
        LOG_EVENT_STRING(AUDITD_LOG_TAG, strp);
        free(strp);
    }
    va_end(ap);
    return 0;
}

int selinux_vendor_log_callback(int type, const char *fmt, ...)
{
    va_list ap;
    int priority;
    char *strp;

    switch(type) {
    case SELINUX_WARNING:
        priority = ANDROID_LOG_WARN;
        break;
    case SELINUX_INFO:
        priority = ANDROID_LOG_INFO;
        break;
    default:
        priority = ANDROID_LOG_ERROR;
        break;
    }

    va_start(ap, fmt);
    if (vasprintf(&strp, fmt, ap) != -1) {
        LOG_PRI(priority, "SELinux", "%s", strp);
        free(strp);
    }
    va_end(ap);
    return 0;
}