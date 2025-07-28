;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;; sss is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; sss is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with sss.  If not, see <https://www.gnu.org/licenses/>.

text-mode :when (bound-and-true-p git-commit-mode)

(feature-commit "# Introduce a new feature." n "#" n
         "✨ feature: " p n n p n n
          "Keywords: " p)

(bug-commit "# Fix a bug." n "#" n
     "🐛 bug: " p n n p n n
      "Keywords: " p)

(docs-commit "# Update documentation." n "#" n
      "📝 docs: " p n n p n n
       "Keywords: " p)

(style-commit "# Style changes to code or appearance." n "#" n
       "🎨 style: " p n n p n n
       "Keywords: " p)

(refactor-commit "# Refactor and improve code and algorithms." n "#" n
                 "♻️ refactor: " p n n p n n
                 "Keywords: " p)

(performance-commit "# Improve performance" n "#" n
                    "🚀 performance: " p n n p n n
                    "Keywords: " p)

(test-commit "# Test or work on exiting tests." n "#" n
             "🧪 test: " p n n p n n
             "Keywords: " p)

(chore-commit "# Tweak the project, and other general maintenance." n "#" n
             "🛠️ chore: " p n n p n n
             "Keywords: " p)

(revert-commit "# Revert changes from a previous commit or decision." n "#" n
             "⏪️ revert: " p n n p n n
             "Keywords: " p)

(add-dependency-commit "# Introduce a new dependency." n "#" n
             "➕ add-dependency: " p n n p n n
             "Keywords: " p)

(remove-dependency-commit "# Remove a dependency." n "#" n
             "➖ remove-dependency: " p n n p n n
             "Keywords: " p)

(update-commit "# Update the project or a dependency." n "#" n
             "⬆️ update: " p n n p n n
             "Keywords: " p)

(delete-commit "# Delete code or files." n "#" n
             "🗑️ delete: " p n n p n n
             "Keywords: " p)

(wip-commit "# " n "# Work in progress, still in development (use carefully)" n
             "🚧 work-in-progress: " p n n p n n
             "Keywords: " p)

(package-commit "# Change the build system, dependencies or packaging" n "#" n
             "📦 package: " p n n p n n
             "Keywords: " p)

